class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    if current_user&.author_of?(answer)
      answer.destroy
    end
  end

  def update
    if current_user&.author_of?(answer)
      answer.update(params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy]))
      answer.files.attach(params[:answer][:files])
      answer.save
    end
  end

  def best
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user&.author_of?(@question)
      @answer.is_best!
      if @question.badge
        @answer.user.badges.push(@question.badge)
      end
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
