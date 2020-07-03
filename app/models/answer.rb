class Answer < ApplicationRecord
  include HasLinks
  # include Ratable
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  def is_best!
    Answer.transaction do
      unless best
        question.answers.find_by(best: true)&.update!(best: false)
        update!(best: true)
        if question.badge
          user.badges.push(question.badge)
        end
      end
    end
  end
end
