class AddUniqueIndexToProducts < ActiveRecord::Migration[7.1]
  def change
    add_index :products, [:name, :user_id], unique: true
  end
end
