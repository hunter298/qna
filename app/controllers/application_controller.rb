class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_params

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
