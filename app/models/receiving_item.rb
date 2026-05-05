class ReceivingItem < ApplicationRecord
  belongs_to :receiving
  belongs_to :item

  validates :receiving, presence: true
  validates :item, presence: true
  validates :qty, presence: true
  validates :cost, presence: true
end
