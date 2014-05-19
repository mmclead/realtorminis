FactoryGirl.define do

  factory :user do
    name Faker::Name.name
    web_site Faker::Internet.domain_name
    email Faker::Internet::email
    password "1234Mini"
    password_confirmation "1234Mini"
    contact_email Faker::Internet::email
    phone_number Faker::PhoneNumber.cell_phone
    dre_number Faker::Number.number(10)
    tag_line Faker::Lorem.sentence(4)
  end
end