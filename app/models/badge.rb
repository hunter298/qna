class Badge < ApplicationRecord
  belongs_to :question
  has_many :achievements, dependent: :destroy
  belongs_to :user, optional: true

  validates :name, presence: true

  has_one_attached :icon
end
