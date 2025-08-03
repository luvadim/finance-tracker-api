class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :telegram_id

      t.timestamps
    end
    add_index :users, :telegram_id, unique: true
  end
end
