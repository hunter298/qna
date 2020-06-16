class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.update(user: current_user)
  end

  def destroy
    if current_user&.author_of?(answer)
      answer.destroy
      flash_message = { alert: 'Answer deleted successfully' }
    end
    redirect_to question_path(answer.question), flash_message || { notice: "You're not authorized to delete this answer" }
  end

  def update
    answer.update(answer_params)
    @question = @answer.question
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
end
