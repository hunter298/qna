FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.current }

    trait :invalid do
      email { 'invalid_email' }
      password { nil }
      password_confirmation { 'incorrect' }
    end
  end
end
