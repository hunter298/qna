class DailyDigestService
  def send_digest
    User.find_each do |user|
      questions = Question.where(created_at: (Time.current - 1.day)..Time.current).pluck(:title)
      DailyDigestMailer.digest(user, questions).deliver_later
    end
  end
end