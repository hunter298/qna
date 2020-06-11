class AddQuestionsUserIdNotNullContstraint < ActiveRecord::Migration[6.0]
  def change
    change_column_null :questions, :user_id, false
  end
end
