class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def is_best!
    unless best
      question.answers.where(best: true).update_all(best: false)
      update(best: true)
    end
  end
end
