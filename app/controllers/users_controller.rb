class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show oauth_email_confirmation]

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    @questions = @user.questions
    @answers = @user.answers
    @comments = @user.comments
  end

  def oauth_email_confirmation
    password = Devise.friendly_token[0, 20]
    email = params[:email]
    @user = User.new(email: email, password: password, password_confirmation: password)
    authorize! :oauth_email_confirmation, @user

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