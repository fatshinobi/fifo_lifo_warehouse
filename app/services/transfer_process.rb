# Service object to handle creation and cleanup of InventoryTransaction records for a Transfer.
# It mirrors the behavior of ShipmentProcess but handles moving items between two storages.
#
# Rules:
# - When a transfer's stock_state changes to :processed, create inventory transactions
#   for each TransferItem using InventoryTransaction.get_batches_for(item_id, storage_id, qty).
#   For each batch returned, two InventoryTransaction records are created:
#     1. Outgoing transaction from the source storage (negative quantity).
#     2. Incoming transaction to the destination storage (positive quantity).
# - When a transfer's stock_state changes to :draft, remove any existing inventory transactions
#   linked to that transfer.

class TransferProcess
  def initialize(transfer)
    @transfer = transfer
  end

  def call
    if @transfer.draft?
      cleanup_if_draft
    elsif @transfer.processed?
      create_transactions
    end
  end

  private

  def cleanup_if_draft
    InventoryTransaction.where(operation: @transfer).delete_all
  end

  def create_transactions
    ActiveRecord::Base.transaction do
      @transfer.transfer_items.find_each do |ti|
        # Retrieve FIFO batches for the required quantity from the source storage
        batches = InventoryTransaction.get_batches_for(ti.item_id, @transfer.storage_id, ti.qty)
        batches.each do |batch|
          # Outgoing transaction (source storage)
          InventoryTransaction.create!(
            item_id: ti.item_id,
            storage_id: @transfer.storage_id,
            qty: -batch[:qty],
            cost: batch[:cost],
            batch_number: batch[:batch_number],
            operation: @transfer,
            transaction_time: batch[:batch_time] || Time.now
          )
          # Incoming transaction (destination storage)
          InventoryTransaction.create!(
            item_id: ti.item_id,
            storage_id: @transfer.storage_to_id,
            qty: batch[:qty],
            cost: batch[:cost],
            batch_number: batch[:batch_number],
            operation: @transfer,
            transaction_time: batch[:batch_time] || Time.now
          )
        end
      end
    end
  end
end
