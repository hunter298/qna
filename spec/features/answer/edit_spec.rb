require 'rails_helper'

feature 'user can edit his answer', "
in order to correct mistakes
as an author if answer,
I'd like to be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit'

      within('.answers') do
        fill_in 'answer_body', with: 'corrected answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'corrected answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      click_on 'Edit'

      within('.answers') do
        fill_in 'answer_body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content answer.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit some other user answer' do
      click_on 'Log out'
      sign_in(other_user)
      visit question_path(question)

      within('.answers') do
        expect(page).to_not have_content 'Edit'
      end
    end

    scenario 'tries to add files during editing', js: true do
      click_on 'Edit'

      within('.answers') do
        fill_in 'answer_body', with: 'corrected answer'
        attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'
      end
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'tries to add links during editing', js: true do
      click_on 'Edit'
      within('.answers') do
        click_on 'add link'

        fill_in 'Link name', with: 'Test link name'
        fill_in 'Url', with: 'http://test.link/'

        click_on 'Save'
      end

      expect(page).to have_link 'Test link name', href: 'http://test.link/'
    end

    scenario 'tries to delete link from question', js: true do
      within('.answers') do
        click_on 'Edit'
        click_on 'add link'
        fill_in 'Link name', with: 'Test link name'
        fill_in 'Url', with: 'http://test.link/'
        click_on 'Save'
      end

      within('.answers') do
        click_on 'Edit'
        click_on 'remove link'
        click_on 'Save'
      end

      expect(page).to_not have_link 'test', href: 'http://test.link'
    end
  end
end
