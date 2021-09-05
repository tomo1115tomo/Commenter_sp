class AddToColumnToFriend < ActiveRecord::Migration[6.1]
  def up
    add_column :friends, :user_id, :integer
    add_column :friends, :friend_id, :integer
  end
end
