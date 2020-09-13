class Api::V1::AnswersController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: %i[create destroy]
  skip_authorization_check only: [:destroy]

  def index
    authorize! :read, Answer
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    render json: @answers, adapter: :json, each_serializer: ListAnswerSerializer
  end

  def show
    authorize! :read, Answer
    @answer = Answer.find(params[:id])
    render json: @answer, adapter: :json
  end

  def create
    authorize! :create, Answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_resource_owner))

    respond_to do |format|
      format.json do
        if @answer.save
          render json: @answer, adapter: :json, status: :created
        else
          render json: {errors: @answer.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    begin
      @answer = Answer.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @answer = nil
      @error = e.message
    end
    respond_to do |format|
      format.json do
        if @answer
          authorize! :destroy, @answer
          @answer.destroy
          render json: {message: 'Answer deleted'}, status: :ok
        else
          render json: {error: @error}, status: 204
        end
      end
    end
  end

  def edit
    @answer = Answer.find(params[:id])
    authorize! :update, @answer
    render json: @answer, adapter: :json
  end

  def update
    @answer = Answer.find(params[:id])
    authorize! :update, @answer
    if @answer.update(answer_params)
      render json: @answer, adapter: :json
    else
      render json: {error: @answer.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    if action_name == 'create'
      params.require(:answer).permit(:body, links_attributes: [:name, :url])
    else
      params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy])
    end
  end
end