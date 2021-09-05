class AddColumnToComment < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :sender_id, :integer
    add_column :comments, :receiver_id, :integer
  end
end
