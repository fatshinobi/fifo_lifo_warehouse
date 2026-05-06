class Shipment < ApplicationRecord
  belongs_to :storage
  has_many :shipment_items, dependent: :destroy
  accepts_nested_attributes_for :shipment_items, allow_destroy: true
  # Stock state enum: draft (0) or processed (1)
  enum stock_state: { draft: 0, processed: 1 }
  # Validations to ensure required fields are present
  validates :shipped_at, presence: true
  validates :storage, presence: true

  def storage_name
    storage.name
  end

  def formatted_id
    "Shipment-#{id}"
  end

  def formatted_shipped_at
    shipped_at.strftime("%F %T")
  end
end
