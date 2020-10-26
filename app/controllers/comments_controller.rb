class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: %i[create]

  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    authorize! :create, @comment

    respond_to do |format|
      format.json do
        if @comment.save
          render json: { comment: @comment, user: @comment.user }
        else
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_commentable
    if params.key?('question_id')
      @commentable = Question.find(params[:question_id])
      @question = @commentable
    elsif params.key?('answer_id')
      @commentable = Answer.find(params[:answer_id])
      @question = @commentable.question
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    unless @comment.errors.any?
      ActionCable.server.broadcast "comments-on-question-#{@question.id}-page", { comment: @comment, user: @comment.user }
    end
  end
end
