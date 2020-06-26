require 'rails_helper'

feature 'user can add links to question', %q{
in order to provide additional details to my question
as an author of question
I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/hunter298/4731c0b30eac700ea90c6ec5093157fe' }

  scenario 'user add link when ask question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'New question'
    fill_in 'Body', with: 'New text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create Question'

    expect(page).to have_link 'My gist', href: gist_url
  end
end