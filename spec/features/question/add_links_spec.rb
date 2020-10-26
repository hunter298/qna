require 'rails_helper'

feature 'user can add links to question', "
in order to provide additional details to my question
as an author of question
I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/hunter298/0b36c45df3e2a79aed5a178e6cca01ac' }

  describe 'user add link when ask question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'New question'
      fill_in 'Body', with: 'New text'
    end

    scenario 'with valid data' do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: 'http://google.com/'

      click_on 'Create Question'

      expect(page).to have_link 'My link', href: 'http://google.com/'
    end

    scenario 'with invalid data' do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: 'invalid_link'

      click_on 'Create Question'

      expect(page).to have_content 'Links url is not a valid URL'
    end

    scenario 'link is gist' do
      fill_in 'Link name', with: 'Gist link'
      fill_in 'Url', with: gist_url

      click_on 'Create Question'

      expect(page).to have_content 'test gist'
    end

    scenario 'with multiple links', js: true do
      click_on 'add link'

      expect(page).to have_selector('.nested-fields', count: 2)
    end
  end
end
