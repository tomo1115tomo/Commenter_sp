class AddColumnToComment < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :emotion, :integer
    add_column :comments, :expression, :integer
  end
end
