require 'rails_helper'

feature 'user can add links to answer', %q{
in order to provide additional details to my answer
as an author of answer
I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/hunter298/0b36c45df3e2a79aed5a178e6cca01ac' }

  describe 'user add link when answering the question' do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'answer_body', with: 'Some test'
    end

    scenario 'with valid data', js: true do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: 'http://google.com/'

      click_on 'Create Answer'

      expect(page).to have_link 'My link', href: 'http://google.com/'
    end

    scenario 'with invalid data', js: true do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: 'invalid_link'

      click_on 'Create Answer'

      expect(page).to have_content 'Links url is not a valid URL'
    end

    scenario 'link is gist', js: true do
      fill_in 'Link name', with: 'Gist link'
      fill_in 'Url', with: gist_url

      click_on 'Create Answer'

      expect(page).to have_content 'test gist'
    end

    scenario 'with multiple links', js: true do
      click_on 'add link'

      expect(page).to have_selector('.nested-fields', count: 2)
    end
  end
end