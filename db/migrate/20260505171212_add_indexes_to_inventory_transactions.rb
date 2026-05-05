class AddIndexesToInventoryTransactions < ActiveRecord::Migration[8.1]
  def change
    # Queries frequently filter by transaction_time, batch_number, item_id and storage_id
    # Adding individual indexes for each column and a composite index for the most common combination.
    add_index :inventory_transactions, :transaction_time
    add_index :inventory_transactions, :batch_number

    # Composite index to speed up queries that filter by item, storage and time together
    add_index :inventory_transactions, [ :item_id, :storage_id, :batch_number, :transaction_time ]
  end
end
