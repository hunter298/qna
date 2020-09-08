class SubscriptionsController < ApplicationController
  def create
    authorize! :create, Subscription
    @subscription = question.subscriptions.create(user: current_user)
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question
end
