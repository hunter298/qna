class SubscriptionsController < ApplicationController
  def create
    authorize! :create, Subscription
    respond_to do |format|
      format.json do
        if Subscription.where(question: question, user: current_user).empty?
          @subscription = question.subscriptions.create(user: current_user)
          render json: @subscription.id
        end

      end
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription
    respond_to do |format|
      format.json do
        @subscription.destroy
        render json: { message: 'Unsubscribed', status: :ok }
      end
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question
end
