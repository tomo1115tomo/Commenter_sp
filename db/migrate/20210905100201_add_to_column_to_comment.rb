class AddToColumnToComment < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :room_id, :integer
  end
end
