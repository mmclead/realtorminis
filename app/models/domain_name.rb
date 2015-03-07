class DomainName < ActiveRecord::Base
  AVAILABILITY_VALUES = ['AVAILABLE']
  belongs_to :listing
  store_accessor :details, :operation_id, :status

  def purchase_domain_from_route53 domain_name
    self.name = domain_name
    r53domains = route53DomainsResource("#{ENV['AWS_SITE_BUCKET_REGION']}")
    return false unless domain_is_available?(domain_name, r53domains)

    self.operation_id = r53domains.register_domain(
      domain_name: domain_name,
      duration_in_years: 1,
      auto_renew: false,
      admin_contact: Settings.admin_contact
      registrant_contact: Settings.registrant_contact
      tech_contact: Settings.tech_contact
    )
    self.status = r53domains.GetOperationDetail(operation_id: self.operation_id)
  end


  def route_domain_to_listing_site
    return false unless domain_is_purchased?
  end


  def domain_is_available? domain_name, client = nil
    client ||= route53DomainsResource("#{ENV['AWS_SITE_BUCKET_REGION']}")
    
    domain_availability = r53domains.check_dmain_availability(domain_name: domain_name).availability
    AVAILABILITY_VALUES.include? domain_availability
  end

  private 
  def domain_is_purchased? client = nil
    return true if status.status == "COMPLETE"
    client ||= route53DomainsResource("#{ENV['AWS_SITE_BUCKET_REGION']}")

    self.status = client.GetOperationDetail(operation_id: self.operation_id)
    status.status == "COMPLETE"
  end
end