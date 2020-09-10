class NewAnswerNoticeService
  def send_notice(answer)
    subscriptions = Subscription.where(question: answer.question)
    subscriptions.find_each(batch_size: 500) do |sub|
      NewAnswerNoticeMailer.notice(sub.user, answer).deliver_later
    end
  end
end