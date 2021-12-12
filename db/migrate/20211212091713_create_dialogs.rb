class CreateDialogs < ActiveRecord::Migration[7.0]
  def change
    create_table :dialogs do |t|
      t.integer :user1
      t.integer :user2

      t.timestamps
    end
  end
end
