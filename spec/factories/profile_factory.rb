# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    user 
    
    profile_pic nil
    logo nil
    name Faker::Name.name
    web_site Faker::Internet.domain_name
    contact_email Faker::Internet::email
    phone_number Faker::PhoneNumber.cell_phone
    dre_number Faker::Number.number(10)
    tag_line Faker::Lorem.sentence(4)
  end
end
