class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :userid1
      t.string :userid2

      t.timestamps
    end
  end
end
