class Api::V1::QuestionsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: %i[create destroy]
  skip_authorization_check only: [:destroy]

  def index
    authorize! :read, Question
    @questions = Question.all
    render json: @questions, adapter: :json
  end

  def show
    authorize! :read, Question
    @question = Question.find(params[:id])
    render json: @question, adapter: :json
  end

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.new(question_params)

    respond_to do |format|
      format.json do
        if @question.save
          render json: @question, adapter: :json, status: :created
        else
          render json: {errors: @question.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    respond_to do |format|
      format.json do
        if @question
          authorize! :destroy, @question
          @question.destroy
          render json: {message: 'Question deleted'}, status: :ok
        else
          render json: {error: @error}, status: 204
        end
      end
    end
  end

  def edit
    @question = Question.find(params[:id])
    authorize! :update, @question
    render json: @question, adapter: :json
  end

  def update
    @question = Question.find(params[:id])
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question, adapter: :json
    else
      render json: {error: @question.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def question_params
    if action_name == 'create'
      params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy],
                                       badge_attributes: [:name, :icon])
    else
      params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy])
    end
  end
end