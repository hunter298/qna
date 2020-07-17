class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  scope :persisted, -> { where 'id IS NOT NULL' }
end
