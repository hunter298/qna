class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "comments-on-question-#{params['id']}-page"
  end
end
