class AddBestToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean
    change_column_default :answers, :best, { from: nil, to: false }
  end
end
