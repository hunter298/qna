require 'rails_helper'

feature 'user can add links to answer', %q{
in order to provide additional details to my answer
as an author of answer
I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/hunter298/4731c0b30eac700ea90c6ec5093157fe' }

  scenario 'user add link when ask question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer_body', with: 'New answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create Answer'

    expect(page).to have_link 'My gist', href: gist_url
  end
end