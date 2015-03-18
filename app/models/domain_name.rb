class DomainName < ActiveRecord::Base
  AVAILABILITY_VALUES = ['AVAILABLE']
  COMPLETE_STATUS = 'COMPLETE'
  DNS_IN_SYNC = 'INSYNC'

  include AwsConnection

  belongs_to :listing
  validates :name, presence: true, uniqueness: true, format: { with: /([0-9a-z_-]+\.)+(be|biz|ca|ch|club|co.uk|com|de|eu|fr|info|link|me.uk|net|mobi|nl|org|org.uk)/, message: 'unsupported TLD (the .com part)'}
  store_accessor :details, :operation_id, :status, :caller_reference, :dns_status

  before_create :set_caller_reference


  def purchase_domain_from_route53
    r53domains = route53DomainsResource
    return false unless domain_is_available?(name, r53domains)

    registered_domain = r53domains.register_domain(
      domain_name: name,
      duration_in_years: 1,
      auto_renew: false,
      admin_contact: Rails.configuration.domains[:admin_contact],
      registrant_contact: Rails.configuration.domains[:registrant_contact],
      tech_contact: Rails.configuration.domains[:tech_contact],
      privacy_protect_admin_contact: true,
      privacy_protect_registrant_contact: true,
      privacy_protect_tech_contact: true,
    )
    self.operation_id =registered_domain.operation_id
    self.status = r53domains.GetOperationDetail(operation_id: self.operation_id)
  end

  def route_domain_to_listing_site
    return false unless domain_is_purchased?
    r53 = route53Resource
    zone_response = r53.create_hosted_zone(
      name: name,
      caller_reference: caller_reference
    )
    self.details[:hosted_zone_id] = zone_response.hosted_zone['id']
    self.details[:hosted_zone_name] = zone_response.hosted_zone['name']
    self.dns_status = zone_response.change_info['status']

    dns_response = r53.change_resource_record_sets(
      hosted_zone_id: details[:hosted_zone_id],
      change_batch: {
        comment: "adding cname for domain to direct to custom-sites.realtorminis.com",
        changes: [
          {
            action: "CREATE",
            resource_record_set: {
              name: name,
              type: 'CNAME',
              resource_records: [
                {
                  value: "custom-sites.realtorminis.com.s3-website-us-west-2.amazonaws.com"
                }
              ]
            }
          },
          {
            action: 'CREATE',
            resource_record_set: {
              name: "www.#{name}",
              type: 'A',
              alias_target: {
                hosted_zone_id: details[:hosted_zone_id],
                dns_name: name,
                evaluate_target_health: false
              }
            }
          }
        ]
      }
    )
  end

  def dns_is_complete? r53 = nil
    r53 ||= route53Resource
    response = r53.get_change(id: details[:hosted_zone_id])
    DNS_IN_SYNC == response.change_info['status']
  end

  def domain_is_available? domain_name = self.name, client = nil
    client ||= route53DomainsResource
    domain_availability = client.check_domain_availability(domain_name: domain_name).availability
    AVAILABILITY_VALUES.include? domain_availability
  end
 
  def domain_is_purchased? client = nil
    return true if status.status == "COMPLETE"
    client ||= route53DomainsResource
    new_status = client.GetOperationDetail(operation_id: self.operation_id) rescue "ERROR"
    self.update(status: new_status)
    status.status == COMPLETE_STATUS
  end

  private

  def set_caller_reference
    self.caller_reference = SecureRandom.uuid
  end

end