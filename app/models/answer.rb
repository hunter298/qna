class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, as: :votable, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true

  after_create :send_new_answer_notice

  def is_best!
    Answer.transaction do
      unless best
        question.answers.find_by(best: true)&.update!(best: false)
        update!(best: true)
        user.badges.push(question.badge) if question.badge
      end
    end
  end

  private

  def send_new_answer_notice
    NewAnswerNoticeJob.perform_later(self)
  end
end
