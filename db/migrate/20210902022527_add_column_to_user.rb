class AddColumnToUser < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :image, :string
  end
end
