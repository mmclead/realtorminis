#time is in seconds
Rails.configuration.timeouts = {
  registration_sleep_time: ENV['REGISTRATION_SLEEP_TIME'],
  registration_attempts: ENV['REGISTRATION_ATTEMPTS'],
  routing_attempts: ENV['ROUTING_ATTEMPTS'],
  routing_sleep_time: ENV['ROUTING_SLEEP_TIME']
}