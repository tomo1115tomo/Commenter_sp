class AddColumnsToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :user_id1, :integer
    add_column :rooms, :user_id2, :integer
  end
end
