class DomainRegistrationJob
  include SuckerPunch::Job

  def perform(domain_name_id)
    ActiveRecord::Base.connection_pool.with_connection do
      domain_name = DomainName.find(domain_name_id)
      domain_name.register_domain_with_route53
      count = 0

      while check_is_false and count < Rails.configuration.timeouts[:registration_attempts]
        count+=1
        logger.info "Checking dns status #{count} times"
        sleep(Rails.configuration.timeouts[:registration_sleep_time])
      end

      DomainRoutingJob.new.async.perform(domain_name_id)
    end
  end

  def check_is_false
    if Rails.env.development? or Rails.env.test?
      [ false, false, false, false, false, false, true ].sample
    else
      !domain_name.domain_is_registered?
    end
  end
end