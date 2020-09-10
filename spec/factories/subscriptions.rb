FactoryBot.define do
  factory :subscription do
    user { create(:user) }
    question { create(:question, user: create(:user)) }
  end
end
