class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_params

  check_authorization unless: :devise_controller?

  SEARCH_CLASSES = %w[Question Answer Comment User].freeze

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        path = current_user ? root_path : new_user_session_path
        redirect_to path, alert: exception.message
      end
      format.json { render json: {error: exception.message}, status: :forbidden }
      format.js { head :forbidden }
    end
  end

  def gon_params
    gon.params = params.permit(:id)
    gon.user = current_user&.id
  end
end
