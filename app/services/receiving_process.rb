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
    return unless @receiving.processed?
    ActiveRecord::Base.transaction do
      @receiving.receiving_items.find_each do |ri|
        InventoryTransaction.create!(
          item: ri.item,
          storage: @receiving.storage,
          qty: ri.qty,
          cost: ri.cost,
          batch_number: @receiving.formatted_id,
          operation: @receiving,
          transaction_time: @receiving.received_at
        )
      end
    end
  end
end
