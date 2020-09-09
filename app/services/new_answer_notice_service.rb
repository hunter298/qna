class NewAnswerNoticeService
  def send_notice(answer)
    users = Subscription.where(question: answer.question).map { |sub| sub.user }
    users.each do |user|
      NewAnswerNoticeMailer.notice(user, answer).deliver_later
    end
  end
end