class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_params

  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  def delete_file_attached
    @file = ActiveStorage::Attachment.find(params[:id])
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
