class AddOperationToInventoryTransactions < ActiveRecord::Migration[8.1]
  def change
    # Polymorphic association for operation (e.g., Shipment, Receiving, etc.)
    add_reference :inventory_transactions, :operation, polymorphic: true, index: true
  end
end
