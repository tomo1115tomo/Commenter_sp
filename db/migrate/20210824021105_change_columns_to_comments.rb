class ChangeColumnsToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :roomid, :integer
  end
end
