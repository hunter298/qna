class NewAnswerNoticeMailer < ApplicationMailer
  def notice(user, answer)
    @question_title = answer.question.title
    @answer_body = answer.body
    mail to: user.email
  end
end
