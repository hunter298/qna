require 'rails_helper'

feature 'user can create answer', %q{
in order to help to find solution for other user's question
registered user
should be able to create answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authorized user' do
    background do
      sign_in(user)
      visit questions_path
      click_on question.title
    end
    scenario 'tries to add answer' do
      fill_in 'answer_body', with: 'Some answer'
      click_on 'Create Answer'

      expect(page).to have_content 'Some answer'
    end
  end

  describe 'unauthorized user' do
    background do
      visit questions_path
      click_on question.title
    end
    scenario 'tries to add answer' do
      fill_in 'answer_body', with: 'Some answer'
      click_on 'Create Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end