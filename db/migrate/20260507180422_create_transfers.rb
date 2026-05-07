class CreateTransfers < ActiveRecord::Migration[8.1]
  def change
    create_table :transfers do |t|
      t.references :storage, null: false, foreign_key: true
      t.bigint :storage_to_id, null: false
      t.datetime :transferred_at
      t.integer :stock_state, default: 0, null: false

      t.timestamps
    end
  end
end
