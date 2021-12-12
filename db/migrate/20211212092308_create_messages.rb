class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :dialog
      t.integer :from
      t.string :text

      t.timestamps
    end
  end
end
