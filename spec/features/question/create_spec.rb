require 'rails_helper'

feature 'user can create question', %q{
In order to get answer from community
as an authorized user
i'd like to be able to create a question
} do

  given(:user) { create(:user) }

  context 'Authenticated user' do
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

    scenario 'ask a question with attached file' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Some text'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'miltiple sessions' do
    scenario 'question appears on another screen', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('other_user') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'New question'
        fill_in 'Body', with: 'Some text'

        click_on 'Create Question'
      end

      Capybara.using_session('other_user') do
        expect(page).to have_content 'New question'
      end

    end
  end

  scenario 'unauthenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You are not authorized to access this page.'
  end
end