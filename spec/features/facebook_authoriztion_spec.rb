require 'rails_helper'

feature 'user can be authorized with facebook', %q{
in order to simplify sign up procedure
I, as facebook user
want to be able to sign up and login with facebook
} do
  background do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  context 'user does not exist but has facebook account' do
    scenario 'user tries to sign up with facebook' do
      clear_emails

      visit new_user_session_path
      click_on 'Sign in with Facebook'
      fill_in :email, with: 'test@example.com'
      click_on 'Save'
      open_email('test@example.com')

      expect(current_email).to have_content 'You can confirm your account email through the link below:'

      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  context 'user has authorization with facebook' do
    given(:user) { create(:user) }

    background do
      user.update(confirmed_at: Time.current)
      user.authorizations.create!(provider: 'facebook', uid: '12345')
    end

    scenario 'tries to sign in with with facebook' do
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end

  context 'user exists but not authorized with facebook' do
    given!(:user) { create(:user, email: 'test@example.com') }

    scenario 'user tries to sign up with facebook' do
      clear_emails

      visit new_user_session_path
      click_on 'Sign in with Facebook'
      fill_in :email, with: 'test@example.com'
      click_on 'Save'
      expect(page).to have_content 'Email has already been taken'
    end
  end
end