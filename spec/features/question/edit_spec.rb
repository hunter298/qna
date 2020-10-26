require 'rails_helper'

feature 'user can edit his questions', "
in order to correct mistakes
as a creator of question
i'd like to be able to edit it
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to edit his question with valid data', js: true do
      click_on 'Edit question'
      fill_in 'Title', with: 'New title'
      fill_in 'Body', with: 'New body'
      click_on 'Update Question'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'New title'
      expect(page).to have_content 'New body'
    end

    scenario 'tries to edit his question with invalid data', js: true do
      click_on 'Edit question'
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Update Question'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      click_on 'Log out'
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_content 'Edit question'
    end

    scenario 'tries to add new files during editing', js: true do
      click_on 'Edit question'
      fill_in 'Title', with: 'New title'
      fill_in 'Body', with: 'New body'
      attach_file 'question_files',
                  ["#{Rails.root}/spec/support/controller_helpers.rb", "#{Rails.root}/spec/support/feature_helpers.rb"]

      click_on 'Update Question'

      expect(page).to have_link 'controller_helpers.rb'
      expect(page).to have_link 'feature_helpers.rb'
    end

    scenario 'tries to add links during editing', js: true do
      click_on 'Edit question'
      within('.question-edit-form') do
        click_on 'add link'

        fill_in 'Link name', with: 'Test link name'
        fill_in 'Url', with: 'http://test.link/'

        click_on 'Update Question'
      end

      expect(page).to have_link 'Test link name', href: 'http://test.link/'
    end

    scenario 'tries to delete link from question', js: true do
      click_on 'Edit question'

      within('.question-edit-form') do
        click_on 'add link'
        fill_in 'Link name', with: 'Test link name'
        fill_in 'Url', with: 'http://test.link/'
        click_on 'Update Question'
      end

      click_on 'Edit question'

      within('.question-edit-form') do
        click_on 'remove link'
        click_on 'Update Question'
      end

      expect(page).to_not have_link 'test', href: 'http://test.link'
    end
  end

  scenario 'unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_content 'Edit question'
  end
end
