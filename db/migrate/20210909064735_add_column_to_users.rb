class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :description, :text
  end
end
