class Badge < ApplicationRecord
  belongs_to :question
  has_many :achievements, dependent: :destroy
  has_many :users, through: :achievements

  validates :name, presence: true

  has_one_attached :icon
end
