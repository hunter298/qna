class UsersController < ApplicationController
  def oauth_email_confirmation
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: params[:email], password: password, password_confirmation: password)
    user.authorizations.create(provider: session[:provider], uid: session[:uid])
    session[:provider] = nil
    session[:uid] = nil
    current_user.send_confirmation_instructions
    redirect_to root_path, notice: 'Check Your e-mailbox to complete reigstration'
  end
end