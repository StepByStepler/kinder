class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.integer :user_id
      t.integer :target_id
      t.boolean :is_like

      t.timestamps
    end
  end
end
