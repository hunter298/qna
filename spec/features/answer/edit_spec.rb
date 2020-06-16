require 'rails_helper'

feature 'user can edit his answer', %q{
in order to correct mistakes
as an author if answer,
I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'

      within('.answers') do
        fill_in 'answer_body', with: 'corrected answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'corrected answer'
        expect(page).to_not have_selector 'textarea'
      end


    end

    scenario 'edits his answer with errors'

    scenario "tries to edit some other user answer"
  end
end