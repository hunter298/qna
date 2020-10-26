class Api::V1::AnswersController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: %i[create destroy]
  skip_authorization_check only: [:destroy]

  def index
    authorize! :read, Answer
    @answers = question.answers
    render json: @answers, adapter: :json, each_serializer: ListAnswerSerializer
  end

  def show
    authorize! :read, Answer
    @answer = Answer.find(params[:id])
    render json: @answer, adapter: :json
  end

  def create
    authorize! :create, Answer
    @answer = question.answers.new(answer_params.merge(user: current_resource_owner))

    respond_to do |format|
      format.json do
        if @answer.save
          render json: @answer, adapter: :json, status: :created
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    authorize! :destroy, @answer
    respond_to do |format|
      format.json do
        @answer.destroy
        render json: { message: 'Answer deleted' }, status: :ok
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
      render json: { error: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    if action_name == 'create'
      params.require(:answer).permit(:body, links_attributes: %i[name url])
    else
      params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
    end
  end
end
