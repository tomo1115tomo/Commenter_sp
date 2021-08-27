class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends do |t|
      t.string :userid
      t.string :friendid
      t.boolean :request
      t.boolean :allow
      t.integer :roomid

      t.timestamps
    end
  end
end
