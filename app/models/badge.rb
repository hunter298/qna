class Badge < ApplicationRecord
  belongs_to :question
  has_many :achievements
  has_many :users, through: :achievements

  validates :name, presence: true
end
