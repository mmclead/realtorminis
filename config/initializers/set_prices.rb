#prices are in cents
Rails.configuration.prices = {
  basic_listing: ENV['BASIC_LISTING_PRICE'],
  custom_domain: ENV['CUSTOM_DOMAIN_PRICE']
}