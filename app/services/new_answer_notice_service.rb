class NewAnswerNoticeService
  def send_notice(answer)
    NewAnswerNoticeMailer.notice(answer.question.user, answer).deliver_later
  end
end