class CreatePlannedTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :planned_transactions do |t|
      t.string :description
      t.decimal :amount
      t.date :planned_date
      t.string :recurrence
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
