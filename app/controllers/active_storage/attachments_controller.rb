class ActiveStorage::AttachmentsController < ApplicationController

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @file
    if current_user&.author_of?(@file.record)
      @file.purge
    end
  end
end