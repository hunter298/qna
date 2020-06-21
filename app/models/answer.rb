class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def is_best!
    Answer.transaction do
      unless best
        question.answers.find_by(best: true)&.update!(best: false)
        update!(best: true)
      end
    end
  end
end
