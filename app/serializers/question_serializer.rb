class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :user_id

  has_many :answers
  has_many :comments
  has_many :links

  def short_title
    object.title.truncate(7)
  end
end
