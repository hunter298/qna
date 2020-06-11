require 'rails_helper'

feature 'user can sign out', %q{
in order to terminate my user session
I, as authorized user
want to be able to sign out
} do
  given(:user) { create(:user) }

  before { sign_in(user) }

  scenario "tries to sign out" do
    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully'
  end
end