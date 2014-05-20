FactoryGirl.define do

  factory :user do
    
    email Faker::Internet::email
    password "1234Mini"
    password_confirmation "1234Mini"

    after(:create) do |user|
      create_list(:profile, 1, user: user)
    end
  end
end