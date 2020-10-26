require 'rails_helper'

feature 'user can sign up', '
in order to use all functionality of  application
any unauthenticated user
can sign up to be able to log in
' do
  background do
    visit new_user_registration_path
  end

  context 'new user' do
    given(:user) { build(:user) }
    given(:user_invalid) { build(:user, :invalid) }

    scenario 'tries to register with valid data' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      click_on 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    end

    scenario 'tries to register with invalid data' do
      fill_in 'Email', with: user_invalid.email
      fill_in 'Password', with: user_invalid.password
      fill_in 'Password confirmation', with: user_invalid.password_confirmation
      click_on 'Sign up'

      expect(page).to have_content 'Email is invalid'
      expect(page).to have_content "Password can't be blank"
      expect(page).to have_content "Password confirmation doesn't match"
    end
  end

  context 'already registered user' do
    given(:user) { create(:user) }

    scenario 'tries to sign up again' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
