class AnswersController < ApplicationController
  before_action :authenticate!

  def create
    @answer = question.answers.new(answer_params)
    @answer.update(user: current_user)
  end

  def destroy
    if current_user&.author_of?(answer)
      answer.destroy
    end
  end

  def update
    if current_user&.author_of?(answer)
      answer.update(answer_params)
      @question = @answer.question
    end
  end

  def best
    @answer = Answer.find(params[:id])
    # if current_user&.author_of?(@answer.question)
      @answer.is_best!
    # end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end

  def authenticate!
    return true if user_signed_in?

    redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.'
  end
end
