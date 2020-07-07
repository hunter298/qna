module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_ratable, only: %i[upvote downvote]
  end

  def upvote
    respond_to do |format|
      format.json do
        unless current_user&.author_of?(@votable)
          @votable.upvote(current_user)
          render json: @votable.votes.sum(:useful)
        else
          head 403
        end
      end
    end
  end

  def downvote
    respond_to do |format|
      format.json do
        unless current_user&.author_of?(@votable)
          @votable.downvote(current_user)
          render json: @votable.votes.sum(:useful)
        else
          head 403
        end
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_ratable
    @votable = model_klass.find(params[:id])
  end
end