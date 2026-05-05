class Receiving < ApplicationRecord
  belongs_to :storage
  has_many :receiving_items, dependent: :destroy
  accepts_nested_attributes_for :receiving_items, allow_destroy: true
  # Validations to ensure required fields are present
  validates :received_at, presence: true
  validates :storage, presence: true

  def storage_name
    storage.name
  end

  def formatted_id
    "Receiving-#{id}"
  end

  def formatted_received_at
    received_at.strftime("%F %T")
  end
end
