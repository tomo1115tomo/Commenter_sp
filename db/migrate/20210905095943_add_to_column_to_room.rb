class AddToColumnToRoom < ActiveRecord::Migration[6.1]
  def up
    add_column :rooms, :room_id, :integer
  end
end
