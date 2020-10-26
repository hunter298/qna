class ActiveStorage::AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @file
    @file.purge
  end
end
