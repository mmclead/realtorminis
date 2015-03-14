# AWS.config(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key=> ENV['AWS_SECRET_ACCESS_KEY'])
Aws.config[:credentials] = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
if Rails.env.development?
  Aws.config[:ssl_verify_peer] = false
end