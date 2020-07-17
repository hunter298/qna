require 'rails_helper'

feature 'user can add comments to question', %q{
in order to clarify some moments
as an authenticated user
I'd like to be able to leave comments to question
} do
  given(:user) { create(:user) }
  given(:question) {create(:question, user: user) }

  context 'authenticated user' do
    scenario 'tries to leave a comment' do
      visit question_path(question)
      fill_in 'comment_body', with: 'some text'
      click_on 'Leave comment'

      expected(page).to have_content 'some text'
    end
  end

  context 'unauthenticated user' do
    scenario 'tries to leave comment' do
      visit question_path(question)
      fill_in 'comment_body', with: 'some text'
      click_on 'Leave comment'

      expected(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end