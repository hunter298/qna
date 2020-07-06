FactoryBot.define do
  factory :vote do
    user { nil }
    votable { nil }
    useful { false }
  end
end
