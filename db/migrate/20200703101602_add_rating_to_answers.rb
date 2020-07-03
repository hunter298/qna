class AddRatingToAnswers < ActiveRecord::Migration[6.0]
  def up
    add_column :answers, :rating, :integer, default: 0
    Answer.update_all(rating: 0)
    change_column_null :answers, :rating, false
  end

  def down
    remove_column :answers, :rating
  end
end
