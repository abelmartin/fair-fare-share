class AddUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, limit: 16
      t.string :last_name, limit: 16
      t.string :email, limit: 64
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
