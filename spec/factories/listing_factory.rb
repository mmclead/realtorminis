FactoryGirl.define do
  factory :listing do  
    address Faker::Address.street_address
    title Faker::Lorem.sentence(5)
    price Faker::Commerce.price
    bedrooms (1..10).to_a.sample
    bathrooms (1..10).to_a.sample
    sq_ft (500..3500).to_a.sample
    short_description Faker::Lorem.paragraph(2)
    description Faker::Lorem.paragraph(6)
  end
end