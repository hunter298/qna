class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def delete_file_attached
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user&.author_of?(@file.record)
      @file.purge
      render partial: 'shared/delete_file_attached'
    end
  end
end
