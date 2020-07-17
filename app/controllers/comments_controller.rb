class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    @comment = @question.comments.new(comment_params.merge(user: current_user))

    respond_to do |format|
      format.json do
        if @comment.save
          render json: {user: @comment.user.email, text: @comment.body}
        else
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end