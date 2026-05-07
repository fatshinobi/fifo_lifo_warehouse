class Transfer < ApplicationRecord
  belongs_to :storage
  belongs_to :storage_to
  has_many :transfer_items, dependent: :destroy
  accepts_nested_attributes_for :transfer_items, allow_destroy: true
  # Enum for stock state with default values
  enum :stock_state, { draft: 0, processed: 1 }
  # Validations to ensure required fields are present
  validates :transferred_at, presence: true
  validates :storage, presence: true
  validates :storage_to, presence: true

  def storage_name
    storage.name
  end

  def storage_to_name
    storage_to.name
  end

  def formatted_id
    "Transfer-#{id}"
  end

  def formatted_transferred_at
    transferred_at.strftime("%F %T")
  end
end
