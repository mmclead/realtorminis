require 'webmock'
include WebMock::API

Realtorminis::Application.configure do
  WebMock.disable_net_connect!(:allow_localhost => true, :allow => [/mandrillapp.com/, /api.stripe.com/, /s3-us-west-2.amazonaws.com/, /s3-us-west-1.amazonaws.com/])


  # succesful test domain name registration
  stub_request(:post, "https://route53domains.us-east-1.amazonaws.com/").
    with(:body => "{\"CustomDomainName\":\"test.com\"}",
         :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'', 'Content-Type'=>'application/x-amz-json-1.1', 'Host'=>'route53domains.us-east-1.amazonaws.com','X-Amz-Target'=>'Route53Domains_v20140515.CheckDomainAvailability'}).
    to_return(:status => 200, :body => "{\"Availability\":\"AVAILABLE\"}", :headers => {})


  stub_request(:post, "https://route53domains.us-east-1.amazonaws.com/").
  with(:body => "{\"CustomDomainName\":\"test.com\",\"DurationInYears\":1,\"AutoRenew\":false,\"AdminContact\":{\"FirstName\":\"Mason\",\"LastName\":\"McLead\",\"ContactType\":\"COMPANY\",\"OrganizationName\":\"RealtorMinis\",\"AddressLine1\":\"2403 Rockefeller Lane \",\"AddressLine2\":\"Unit A\",\"City\":\"Redondo Beach\",\"State\":\"CA\",\"CountryCode\":\"US\",\"ZipCode\":\"90278\",\"PhoneNumber\":\"+13109621144\",\"Email\":\"mason@realtorminis.com\"},\"RegistrantContact\":{\"FirstName\":\"Mason\",\"LastName\":\"McLead\",\"ContactType\":\"COMPANY\",\"OrganizationName\":\"RealtorMinis\",\"AddressLine1\":\"2403 Rockefeller Lane \",\"AddressLine2\":\"Unit A\",\"City\":\"Redondo Beach\",\"State\":\"CA\",\"CountryCode\":\"US\",\"ZipCode\":\"90278\",\"PhoneNumber\":\"+13109621144\",\"Email\":\"mason@realtorminis.com\"},\"TechContact\":{\"FirstName\":\"Mason\",\"LastName\":\"McLead\",\"ContactType\":\"COMPANY\",\"OrganizationName\":\"RealtorMinis\",\"AddressLine1\":\"2403 Rockefeller Lane \",\"AddressLine2\":\"Unit A\",\"City\":\"Redondo Beach\",\"State\":\"CA\",\"CountryCode\":\"US\",\"ZipCode\":\"90278\",\"PhoneNumber\":\"+13109621144\",\"Email\":\"mason@realtorminis.com\"},\"PrivacyProtectAdminContact\":true,\"PrivacyProtectRegistrantContact\":true,\"PrivacyProtectTechContact\":true}",
       :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'', 'Content-Type'=>'application/x-amz-json-1.1', 'Host'=>'route53domains.us-east-1.amazonaws.com', 'X-Amz-Target'=>'Route53Domains_v20140515.RegisterDomain'}).
  to_return(:status => 200, :body => "{\"OperationId\":\"1234567890\"}", :headers => {})

  stub_request(:post, "https://route53domains.us-east-1.amazonaws.com/").
  with(:body => "{\"OperationId\":\"1234567890\"}",
    :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'', 'Content-Type'=>'application/x-amz-json-1.1', 'Host'=>'route53domains.us-east-1.amazonaws.com','X-Amz-Target'=>'Route53Domains_v20140515.GetOperationDetail'}).
  to_return(:status => 200, :body => "{\"CustomDomainName\":\"test.com\",\"OperationId\":\"1234567890\",\"Status\":\"SUCCESSFUL\"}", :headers => {})


  
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.serve_static_files = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.precompile += %w( preview.js preview.css external.css external.js)
end
