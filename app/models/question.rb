class Question < ApplicationRecord
  include HasLinks
  include Ratable

  has_many :answers, dependent: :destroy
  has_one :badge, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :badge, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true
end
