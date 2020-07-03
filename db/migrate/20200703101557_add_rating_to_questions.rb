class AddRatingToQuestions < ActiveRecord::Migration[6.0]
  def up
    add_column :questions, :rating, :integer, default: 0
    Question.update_all(rating: 0)
    change_column_null :questions, :rating, false
  end

  def down
    remove_column :questions, :rating
  end
end
