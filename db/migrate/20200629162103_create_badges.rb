class CreateBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
