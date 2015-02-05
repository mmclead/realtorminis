FactoryGirl.define do
  factory :site, class: :site do  
    listing
    site_code {Faker::Lorem.paragraph(6)}
  end
end