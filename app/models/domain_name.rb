require 'mandrill'

class DomainName < ActiveRecord::Base
  AVAILABILITY_VALUES = ['AVAILABLE']
  COMPLETE_STATUS = 'COMPLETE'
  DNS_IN_SYNC = 'INSYNC'

  include AwsConnection
  include PurchaseableModel

  SUPPORTED_TLDS = %w[com org net mobi info link be biz ca ch club co.uk de eu fr me.uk nl org.uk]
  belongs_to :listing
  validates :name, presence: true, uniqueness: true, format: { with: /([0-9a-z_-]+\.)+(be|biz|ca|ch|club|co.uk|com|de|eu|fr|info|link|me.uk|net|mobi|nl|org|org.uk)/, message: 'unsupported TLD (the .com part)'}
  store_accessor :details, :operation_id, :domain_status, :caller_reference, :dns_status, :status

  before_create :set_caller_reference, :set_status_to_new

  enum status: [
    :selected, :registered_name, :routed_domain_name, 
    :complete, :registered_name_failed, :routed_domain_name_failed
  ]

  def set_status_to_new
    self.status = :selected
  end

  def email_operations
    mandrill = Mandrill::API.new Rails.configuration.mandrill[:api_key]

    template_name = "custom-domain-purchased"

    template_content = [
      {"content"=>"#{name}", "name"=>"domain_name"},
      {"content"=>"#{status}", "name"=>"domain_name_status"},
      {"content"=>"#{listing.full_address}", "name"=>"listing_address"},
      {"content"=>"#{listing.key_photo}", "name"=>"key_photo"},
    ]
    message = {
      "subject" => "Your domain #{name} is ready",
      "to"=>
        [{"email"=>ENV['support_email'],
            "type"=>"to",
            "name"=>"RM Support for #{listing.user.profile.name}"}]
    }

    async = false

    begin
      result = mandrill.messages.send_template template_name, template_content, message, async
    rescue Mandrill::Error => e
      logger.error "A mandrill error occurred: #{e.class} - #{e.message}"
    end
  end

  def register_domain_with_route53
    r53domains = route53DomainsResource
    return false unless self.is_paid_for?
    return false unless domain_is_available?(name, r53domains)
    debugger
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
    self.operation_id = registered_domain.operation_id
    self.domain_status = r53domains.get_operation_detail(operation_id: self.operation_id)
    self.save
  end

  def route_domain_to_listing_site
    return false unless self.is_paid_for?
    unless domain_is_registered?
      self.registered_name_failed!
      return false
    end

    r53 = route53Resource
    debugger
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
        comment: "adding cname for domain to direct to custom sites endpoint",
        changes: [
          {
            action: "CREATE",
            resource_record_set: {
              name: name,
              type: 'CNAME',
              resource_records: [
                {
                  value: "#{ENV['CUSTOM_SITE_NAME']}"
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
    self.save
  end

  def dns_is_complete? r53 = nil
    r53 ||= route53Resource
    response = r53.get_change(id: details[:hosted_zone_id])

    if DNS_IN_SYNC == response.change_info['status']
      self.routed_domain_name!
      true
    else
      false
    end
  end

  def domain_is_available? domain_name = self.name, client = nil
    client ||= route53DomainsResource
    domain_availability = client.check_domain_availability(domain_name: domain_name).availability
    logger.info "Availability of #{domain_name} is : #{domain_availability}"
    AVAILABILITY_VALUES.include? domain_availability
  end
 
  def domain_is_registered? client = nil
    return false unless self.is_paid_for?
    return true if domain_status == COMPLETE_STATUS
    client ||= route53DomainsResource
    new_status = client.get_operation_detail(operation_id: self.operation_id).domain_status rescue "ERROR"
    completed = domain_status == COMPLETE_STATUS
    
    if completed
      self.domain_status = new_status
      self.registered_name! 
    else
      self.update(domain_status: new_status)
    end

    completed
  end

  def purchase_description
    "Custom Domain Name"
  end

  private

  def set_caller_reference
    self.caller_reference = SecureRandom.uuid
  end

end