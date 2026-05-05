class InventoryTransaction < ApplicationRecord
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
