class DomainRoutingJob
  include SuckerPunch::Job

  def perform(domain_name_id)

    ActiveRecord::Base.connection_pool.with_connection do
      domain_name = CustomDomainName.find(domain_name_id)
      domain_name.route_domain_to_listing_site
      count = 0
      
      while check_is_false(domain_name) and count < Rails.configuration.timeouts[:routing_attempts].to_i
        count+=1
        SuckerPunch.logger.info "Checking dns status #{count} times"
        sleep(Rails.configuration.timeouts[:routing_sleep_time])
      end

      DomainCompleteMailerJob.new.async.perform(domain_name_id)
    end
  end

  def check_is_false(domain_name)
    if Rails.env.development? or Rails.env.test?
      [ false, false, false, false, false, false, true ].sample
    else
      !domain_name.dns_is_complete?
    end
  end

end