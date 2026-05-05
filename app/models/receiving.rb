class Receiving < ApplicationRecord
  belongs_to :storage
  has_many :receiving_items, dependent: :destroy
  accepts_nested_attributes_for :receiving_items, allow_destroy: true
  # Validations to ensure required fields are present
  validates :received_at, presence: true
  validates :storage, presence: true
end
