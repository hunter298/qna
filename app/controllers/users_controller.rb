class UsersController < ApplicationController
  def oauth_email_confirmation
    password = Devise.friendly_token[0, 20]
    email = params[:email]
    @user = User.new(email: email, password: password, password_confirmation: password)

    if @user.save
      @user.authorizations.create(provider: session[:provider], uid: session[:uid])
      session[:provider] = nil
      session[:uid] = nil
      @user.send_confirmation_instructions
      redirect_to root_path, notice: 'Check Your e-mailbox to complete registration'
    else
      render 'shared/facebook_email'
    end
  end
end