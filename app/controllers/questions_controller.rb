class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
    gon.user = current_user&.id
  end

  def show
    @answer = question.answers.new
    @answer.links.build
  end

  def new
    question.links.build
    Badge.new(question: question)
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Question successfully created!'
    else
      render :new
    end
  end

  def update
    if current_user&.author_of?(question)
      question.update(question_params)
      question.files.attach(params[:question][:files]) if params[:question][:files]
    end
  end

  def destroy
    if current_user&.author_of?(question)
      question.destroy
      flash_message = {notice: 'Question deleted successfully'}
    end
    redirect_to questions_path, flash_message || {alert: "You're not authorized to delete this question"}
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    if action_name == 'create'
      params.require(:question).permit(:title, :body, files: [],
                                       links_attributes: [:id, :name, :url, :_destroy],
                                       badge_attributes: [:name, :icon])
    else
      params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy])
    end
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', @question
  end
end
