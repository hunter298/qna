require 'rails_helper'

feature 'user can delete answer', %q{
in order to remove redundant or unnecessary answer
registered user
should be able to delete answer, created by him
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }


  describe 'authorized user' do
    background do

      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to delete own answer' do
      click_link 'Delete', href: answer_path(answer)

      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete another's answer" do
      expect(page).to_not have_link 'Delete', href: answer_path(other_answer)
    end
  end

  scenario 'tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end