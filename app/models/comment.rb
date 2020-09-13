class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user, dependent: :destroy

  validates :body, presence: true

  scope :persisted, -> { where 'id IS NOT NULL' }

  def commentable
    commentable_type&.constantize&.find(commentable_id)
  end
end
