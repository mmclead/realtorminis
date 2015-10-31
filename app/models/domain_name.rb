require 'mandrill'

class DomainName < ActiveRecord::Base
  AVAILABILITY_VALUES = ['AVAILABLE']
  COMPLETE_STATUS = 'SUCCESSFUL'
  DNS_IN_SYNC = 'INSYNC'

  ALIAS_TARGET_HOSTED_ZONE_ID = 'Z2FDTNDATAQYW2'
  ALIAS_TARGET_DNS_NAME = "dantpuzcw717s.cloudfront.net."
  CLOUD_FRONT_ID = 'E2J16G1BIAGO7S'

  include AwsConnection
  include PurchaseableModel

  belongs_to :listing

  SUPPORTED_TLDS = %w[com org net mobi info link be biz ca ch club co.uk de eu fr me.uk nl org.uk]
  validates :name, presence: true, uniqueness: true, format: { with: /([0-9a-z_-]+\.)+(be|biz|ca|ch|club|co.uk|com|de|eu|fr|info|link|me.uk|net|mobi|nl|org|org.uk)/, message: 'unsupported TLD (the .com part)'}
  store_accessor :details, :operation_id, :domain_status, :caller_reference, :dns_status, :status

  before_create :set_caller_reference, :set_status_to_new

  enum status: [
    :selected, :purchased, :registered_name, :routed_domain_name, 
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
      "subject" => "User #{listing.user.email} added domain #{name}, current status: #{status}",
      "to"=>
        [{"email"=>ENV['SUPPORT_EMAIL'],
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
    registered_domain = r53domains.register_domain(
      domain_name: name,
      duration_in_years: 1,
      auto_renew: false,
      admin_contact: Rails.configuration.domains[:admin_contact],
      registrant_contact: Rails.configuration.domains[:registrant_contact],
      tech_contact: Rails.configuration.domains[:tech_contact],
    )
    self.operation_id = registered_domain.operation_id
    self.domain_status = r53domains.get_operation_detail(operation_id: self.operation_id).status
    self.save
  end

  def route_domain_to_listing_site
    return false unless self.is_paid_for?
    unless domain_is_registered?
      self.registered_name_failed!
      return false
    end

    hosted_zone = route53Resource.list_hosted_zones_by_name({dns_name: name}).hosted_zones.first
    logger.info "found hosted zone : #{hosted_zone}"
    self.details[:hosted_zone_id] = hosted_zone['id'].split('/').last
    self.details[:hosted_zone_name] = hosted_zone['name']
    self.dns_status = 'zone_created'
    self.save!

    add_new_aliases_to_cloud_front

    dns_response = route53Resource.change_resource_record_sets({
      hosted_zone_id: details[:hosted_zone_id],
      change_batch: {
        comment: "adding cname for domain to direct to custom sites endpoint",
        changes: [
          {
            action: 'CREATE',
            resource_record_set: {
              name: details[:hosted_zone_name],
              type: 'A',
              alias_target: {
                hosted_zone_id: ALIAS_TARGET_HOSTED_ZONE_ID,
                dns_name: ALIAS_TARGET_DNS_NAME,
                evaluate_target_health: true
              }
            }
          },
          {
            action: 'CREATE',
            resource_record_set: {
              name: "www.#{details[:hosted_zone_name]}",
              type: 'A',
              alias_target: {
                hosted_zone_id: ALIAS_TARGET_HOSTED_ZONE_ID,
                dns_name: ALIAS_TARGET_DNS_NAME,
                evaluate_target_health: true
              }
            }
          }
        ]
      }
    })
    self.save!
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
    new_status = client.get_operation_detail(operation_id: self.operation_id).status rescue "ERROR"
    completed = (new_status == COMPLETE_STATUS)
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

  def add_new_aliases_to_cloud_front
    cf_distro = cfResource.get_distribution({id: CLOUD_FRONT_ID})

    current_aliases = cf_distro.distribution.distribution_config.aliases.items
    new_aliases_list = current_aliases + ["#{details[:hosted_zone_name]}", "www.#{details[:hosted_zone_name]}"]
    

    ##TODO MISSING REQUIRED FIELDS
    cfResource.update_distribution({
      id: CLOUD_FRONT_ID,
      distribution_config: {
        caller_reference: caller_reference,
        aliases: {
          quantity: new_aliases_list.size,
          items: new_aliases_list
        }
      }
    })
  end

  def set_caller_reference
    self.caller_reference = SecureRandom.uuid
  end

end