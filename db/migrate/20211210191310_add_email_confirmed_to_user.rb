class AddEmailConfirmedToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_confirmed, :boolean
  end
end
