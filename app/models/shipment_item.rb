class ShipmentItem < ApplicationRecord
  belongs_to :shipment
  belongs_to :item

  validates :shipment, presence: true
  validates :item, presence: true
  validates :qty, presence: true
  validates :price, presence: true
end
