class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :encrypted_password,
               :string, default: "", null: false

    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime

    add_index :users, :reset_password_token, unique: true

    execute <<~SQL
      UPDATE users
      SET encrypted_password = password_digest
      WHERE password_digest IS NOT NULL
    SQL
  end

  def down
    remove_index :users, :reset_password_token

    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
  end
end
