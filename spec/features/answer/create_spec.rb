require 'rails_helper'

feature 'user can create answer', %q{
in order to help to find solution for other user's question
registered user
should be able to create answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on question.title
    end

    scenario 'tries to add answer with valid data', js: true do
      fill_in 'answer_body', with: 'Some answer'
      click_on 'Create Answer'

      expect(page).to have_content 'Some answer'
    end

    scenario 'tries to add answer with invalid data', js: true do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'add answer with few files attached', js: true do
      fill_in 'answer_body', with: 'Some answer'
      attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Create Answer'

      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end
  end

  describe 'unauthenticated user' do
    background do
      visit questions_path
      click_on question.title
    end

    scenario 'tries to add answer', js: true do
      within '.new-answer' do
        fill_in 'answer_body', with: 'Some answer'
        click_on 'Create Answer'
      end
      expect(page).to_not have_content 'Some answer'
    end
  end

  context 'miltiple sessions' do
    scenario 'answer appears on another screen', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('other_user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer_body', with: 'New answer'

        click_on 'Create Answer'
      end

      Capybara.using_session('other_user') do
        expect(page).to have_content 'New answer'
      end

    end
  end
end