# Service object to handle creation of InventoryTransaction records when a Receiving
# is processed. It maps ReceivingItems to InventoryTransaction according to the
# specification:
#   item_id        -> item_id
#   storage_id     -> InventoryTransaction.storage_id (from Receiving.storage)
#   qty            -> qty
#   cost           -> cost
#   batch_number   -> InventoryTransaction.batch_number (from Receiving.formatted_id)
#   operation      -> the Receiving record itself (polymorphic association)
#   transaction_time -> Receiving.received_at

class ReceivingProcess
  def initialize(receiving)
    @receiving = receiving
  end

  def call
    if @receiving.draft?
      # Ensure no leftover inventory transactions when a receiving is saved as draft.
      cleanup_if_draft
    elsif @receiving.processed?
      # Create inventory transactions for a processed receiving.
      ActiveRecord::Base.transaction do
        @receiving.receiving_items.find_each do |ri|
          InventoryTransaction.create!(
            item: ri.item,
            storage: @receiving.storage,
            qty: ri.qty,
            cost: ri.cost,
            batch_number: @receiving.formatted_id,
            operation: @receiving,
            transaction_time: Time.now
          )
        end
      end
    end
  end

  # Removes inventory transactions linked to the receiving when it is in draft state.
  def cleanup_if_draft
    InventoryTransaction.where(operation: @receiving).delete_all
  end
end
