require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Realtorminis
  class Application < Rails::Application

    # config.force_ssl = true

    config.active_record.raise_in_transactional_callbacks = true
    
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'realtorminis.com',
      user_name:            ENV['SENDING_EMAIL_ADDRESS'],
      password:             ENV['SENDING_EMAIL_ADDRESS_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: true
    }
    config.action_mailer.default_options = {
      from: ENV['DEFAULT_FROM_EMAIL'],
      reply_to: ENV['DEFAULT_FROM_EMAIL']
    }


    SuckerPunch.logger = Logger.new('sucker_punch.log')

  end
end
