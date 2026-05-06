# Service object to handle creation and cleanup of InventoryTransaction records for a Shipment.
# It mirrors the behavior of ReceivingProcess but uses FIFO batch allocation.
#
# Rules:
# - When a shipment's stock_state changes to :processed, create inventory transactions
#   for each ShipmentItem using InventoryTransaction.get_batches_for(item_id, storage_id, qty).
#   For each batch returned, an InventoryTransaction record is created with:
#     batch_number: batch_number from the batch hash
#     item_id:      ShipmentItem.item_id
#     storage_id:   Shipment.storage_id
#     qty:          -batch_qty (negative because items are leaving the storage)
#     cost:         batch_cost
#     operation:    the Shipment record (polymorphic association)
#     transaction_time: current time
# - When a shipment's stock_state changes to :draft, remove any existing inventory transactions
#   linked to that shipment.

class ShipmentProcess
  def initialize(shipment)
    @shipment = shipment
  end

  def call
    if @shipment.draft?
      cleanup_if_draft
    elsif @shipment.processed?
      create_transactions
    end
  end

  private

  def cleanup_if_draft
    InventoryTransaction.where(operation: @shipment).delete_all
  end

  def create_transactions
    ActiveRecord::Base.transaction do
      @shipment.shipment_items.find_each do |si|
        # Retrieve FIFO batches for the required quantity
        batches = InventoryTransaction.get_batches_for(si.item_id, @shipment.storage_id, si.qty)
        batches.each do |batch|
          InventoryTransaction.create!(
            item_id: si.item_id,
            storage_id: @shipment.storage_id,
            qty: -batch[:qty],
            cost: batch[:cost],
            batch_number: batch[:batch_number],
            operation: @shipment,
            transaction_time: Time.now
          )
        end
      end
    end
  end
end

