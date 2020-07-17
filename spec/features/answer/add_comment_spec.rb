require 'rails_helper'

feature 'user can add comments to answer', %q{
in order to clarify some moments
as an authenticated user
I'd like to be able to leave comments to answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'tries to leave a comment', js: true do
      visit question_path(question)
      within".answer" do
        fill_in 'comment_body', with: 'some text'
        click_on 'Leave comment'
      end

      expect(page).to have_content 'some text'
    end

    scenario 'tries to leave a comment with invalid data', js: true do
      visit question_path(question)
      within".answer" do
        fill_in 'comment_body', with: ''
        click_on 'Leave comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'unauthenticated user' do
    scenario 'tries to leave comment' do
      visit question_path(question)
      within".answer" do
        fill_in 'comment_body', with: 'some text'
        click_on 'Leave comment'
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end