module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_votable, only: %i[upvote downvote]
  end

  def upvote
    authorize! :upvote, @votable
    respond_to do |format|
      format.json do
        @votable.upvote(current_user)
        render json: @votable.rating
      end
    end
  end

  def downvote
    authorize! :downvote, @votable
    respond_to do |format|
      format.json do
        @votable.downvote(current_user)
        render json: @votable.rating
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
