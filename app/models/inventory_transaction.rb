class InventoryTransaction < ApplicationRecord
  belongs_to :item
  belongs_to :storage
  belongs_to :operation, polymorphic: true
end
