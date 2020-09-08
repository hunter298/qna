# Preview all emails at http://localhost:3000/rails/mailers/new_answer_notice
class NewAnswerNoticePreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_notice/notice
  def notice
    NewAnswerNoticeMailer.notice
  end

end
