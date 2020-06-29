require 'rails_helper'

feature 'user can create achievement', %q{
in order to motivate other user to answer my question
as an author of question
I'd like to be able to create badge for best answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:badge) { create(:badge, question: question) }

  given(:other_user) { create(:user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }

  scenario "question's author flag some answer as best", js: true do
    sign_in(user)
    visit question_path(question)

    click_link 'Best'
    expect(other_user.badges).to include(badge)
  end
end