FactoryBot.define do
  sequence :body do |n|
    "MyAnswer#{n}"
  end

  factory :answer do
    body
    question { nil }
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
