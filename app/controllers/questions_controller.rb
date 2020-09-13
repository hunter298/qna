class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: %i[index show]

  after_action :publish_question, only: %i[create]

  def index
    authorize! :read, Question
    @questions = Question.all
  end

  def show
    authorize! :read, Question
    @answer = question.answers.new
    @answer.links.build
    @subscription = question.subscriptions.where(user: current_user).first
  end

  def new
    authorize! :create, Question
    question.links.build
    Badge.new(question: question)
  end

  def create
    authorize! :create, Question
    @question = current_user.questions.new(question_params)

    if @question.save
      question.subscriptions.create(user: current_user)
      redirect_to @question, notice: 'Question successfully created!'
    else
      render :new
    end
  end

  def update
    authorize! :update, question
    question.update(question_params)
    question.files.attach(params[:question][:files]) if params[:question][:files]
  end

  def destroy
    authorize! :destroy, question
    question.comments.destroy_all
    question.destroy
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
