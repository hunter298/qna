class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "question-#{params['id']}"
  end

  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
