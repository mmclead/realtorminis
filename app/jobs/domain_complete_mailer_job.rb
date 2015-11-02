require 'mandrill'
class DomainCompleteMailerJob
  include SuckerPunch::Job

  def perform(domain_name_id)
    ActiveRecord::Base.connection_pool.with_connection do
      domain_name = CustomDomainName.find(domain_name_id)
      domain_name.complete!
      mandrill = Mandrill::API.new Rails.configuration.mandrill[:api_key]

      template_name = "custom-domain-complete"

      template_content = [
        {"content"=>"#{domain_name.name}", "name"=>"domain_name"},
        {"content"=>"#{domain_name.status}", "name"=>"domain_name_status"},
        {"content"=>"#{domain_name.listing.full_address}", "name"=>"listing_address"},
        {"content"=>"#{domain_name.listing.key_photo}", "name"=>"key_photo"},
      ]
      message = {
        "subject" => "Custom domain #{domain_name.name} purchased",
        "to"=>
          [{"email"=>"#{domain_name.listing.user.email}",
              "type"=>"to",
              "name"=>"#{domain_name.listing.user.profile.name}"}]
      }

      async = false

      begin
        result = mandrill.messages.send_template template_name, template_content, message, async
      rescue Mandrill::Error => e
        SuckerPunch.logger.error "A mandrill error occurred: #{e.class} - #{e.message}"
        raise
      end

    end
    
  end

end