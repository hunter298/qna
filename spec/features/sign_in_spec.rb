require 'rails_helper'

feature 'User can sign in', '
  in order to ask question,
  I, as an unauthorized user
  want to be able to sign in
' do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    # save_and_open_page
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'unregistered user tries to sign in' do
    fill_in 'Email', with: 'invalid@test.com'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password'
  end
end
