require 'rails_helper'

feature 'user can delete question', %q{
in order to remove redundant or unnecessary question
registered user
should be able to delete question, created by him
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:other_question) { create(:question, user: users[1]) }

  describe 'authenticated user' do
    background do
      sign_in(users[0])
      visit questions_path
    end

    scenario 'tries to delete own question', js: true do
      click_link 'Delete', href: question_path(question)

      expect(page).to_not have_content question.title
    end

    scenario "tries to delete another's question" do
      expect(page).to_not have_link 'Delete', href: question_path(other_question)
    end
  end

  scenario 'unauthenticated user tries to delete question' do
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end