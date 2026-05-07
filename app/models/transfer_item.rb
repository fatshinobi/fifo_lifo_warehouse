class TransferItem < ApplicationRecord
  belongs_to :transfer
  belongs_to :item
end
