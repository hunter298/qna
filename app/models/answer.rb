class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

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
