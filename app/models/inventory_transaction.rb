class InventoryTransaction < ApplicationRecord
  belongs_to :item
  belongs_to :storage
end
