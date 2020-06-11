require 'rails_helper'

feature 'user can create question', %q{
In order to get answer from community
as an authorized user
i'd like to be able to create a question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'tries to create question with valid data' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Some text'
      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created!'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Some text'
    end

    scenario 'tries to create question with invalid data' do
      click_on 'Create Question'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'unauthenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end