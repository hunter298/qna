class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def twitter
    auth = request.env['omniauth.auth']
    if Authorization.where(provider: auth.provider, uid: auth.uid).first
      @user = User.find_for_oauth(request.env['omniauth.auth'])
      if @user&.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
      else
        redirect_to root_path, alert: 'Something went wrong'
      end
    else
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      render 'shared/twitter_email.html.slim'
    end
  end
end