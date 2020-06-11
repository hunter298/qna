class AddUserReferenceToQuestion < ActiveRecord::Migration[6.0]

  def change
    add_reference :questions, :user, null: true, foreign_key: true
  end
end
