FactoryBot.define do
  sequence :url do |n|
    "http://link#{n}.com/"
  end

  factory :link do
    name { 'link' }
    url

    trait :invalid do
      url { 'invalid_url' }
    end
  end
end
