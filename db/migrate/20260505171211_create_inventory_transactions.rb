class CreateInventoryTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_transactions do |t|
      t.datetime :transaction_time
      t.string :batch_number
      t.references :item, null: false, foreign_key: true
      t.references :storage, null: false, foreign_key: true
      t.integer :qty
      t.decimal :cost, precision: 8, scale: 2

      t.timestamps
    end
  end
end
