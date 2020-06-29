FactoryBot.define do
  sequence :name do |n|
    "Badge#{n}"
  end
  factory :badge do
    name
  end
end
