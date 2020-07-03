class Question < ApplicationRecord
  # include Ratable
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable
  has_one :badge, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true

  def upvote
    self.rating += 1
    save
  end

  def downvote
    self.rating -= 1
    save
  end
end
