class AddCurrentAccountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :current_account_id, :bigint
    add_foreign_key :users, :accounts, column: :current_account_id
    add_index :users, :current_account_id
  end
end