class InventoryTransaction < ApplicationRecord
  acts_as_fifo item_field: :item_id, qty_field: :qty, cost_field: :cost, time_field: :transaction_time, batch_field: :batch_number, storage_field: :storage_id

  belongs_to :item
  belongs_to :storage
  belongs_to :operation, polymorphic: true

  def item_name
    item&.name
  end

  def storage_name
    storage&.name
  end

  def formatted_transaction_time
    transaction_time.strftime("%F %T")
  end
end
