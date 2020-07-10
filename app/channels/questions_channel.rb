class QuestionsChannel < ApplicationCable::Channel

  def follow
    stream_from "questions"
  end

  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
