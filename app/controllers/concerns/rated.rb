module Rated
  extend ActiveSupport::Concern

  included do
    # before_action :authenticate_user!
    before_action :set_ratable, only: %i[upvote]
  end

  def upvote
    @ratable.upvote
    render plain: @ratable.rating
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_ratable
    @ratable = model_klass.find(params[:id])
  end
end