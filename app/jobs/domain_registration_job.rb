class DomainRegistrationJob
  include SuckerPunch::Job

  def perform(domain_name_id)
    # SuckerPunch.logger = Logger.new('sucker_punch.log')
    ActiveRecord::Base.connection_pool.with_connection do
      domain_name = DomainName.find(domain_name_id)
      domain_name.register_domain_with_route53
      count = 0

      while domain_is_being_processed? and count < Rails.configuration.timeouts[:registration_attempts].to_i
        count+=1
        SuckerPunch.logger.info "Checking dns status #{count} times"
        sleep(Rails.configuration.timeouts[:registration_sleep_time])
      end

      DomainRoutingJob.new.async.perform(domain_name_id)
    end
  end

  def domain_is_being_processed?
    if Rails.env.development? or Rails.env.test?
      [ false, false, false, false, false, false, true ].sample
    else
      !domain_name.domain_is_registered?
    end
  end
end