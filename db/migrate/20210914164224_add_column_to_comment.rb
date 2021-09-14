class AddColumnToComment < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :title, :text
  end
end
