class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

  after_action :publish_answer, only: %i[create]

  def create
    authorize! :create, Answer
    @answer = question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    authorize! :destroy, answer
    answer.comments.destroy_all
    answer.destroy
  end

  def update
    authorize! :update, answer
    answer.update(answer_params)
    answer.files.attach(params[:answer][:files])
  end

  def best
    @answer = Answer.find(params[:id])
    authorize! :best, answer
    @question = @answer.question
    @answer.is_best! if current_user&.author_of?(@question)
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
    if action_name == 'create'
      params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
    else
      params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
    end
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "answers-for-question-#{question.id}", @answer
  end
end
