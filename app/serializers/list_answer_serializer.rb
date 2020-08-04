class ListAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :created_at, :updated_at
end
