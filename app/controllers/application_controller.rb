class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_params

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    path = current_user ? root_path : new_user_session_path
    redirect_to path, alert: exception.message
  end

  def delete_file_attached
    @file = ActiveStorage::Attachment.find(params[:attachment_id])
    authorize! :delete_file_attached, @file.record
    if current_user&.author_of?(@file.record)
      @file.purge
      render partial: 'shared/delete_file_attached'
    end
  end

  def gon_params
    gon.params = params.permit(:id)
    gon.user = current_user&.id
  end
end
