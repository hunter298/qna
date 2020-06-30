class AddBadgesUserReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :badges, :user
  end
end
