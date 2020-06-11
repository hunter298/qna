class AnswersController < ApplicationController

  before_action :authenticate_user!

  def new

  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question
    else
      render :new
    end
  end

  def destroy
    answer.destroy
    redirect_to question_path(answer.question)
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
