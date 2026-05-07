class Transfer < ApplicationRecord
  belongs_to :storage
  belongs_to :storage_to
end
