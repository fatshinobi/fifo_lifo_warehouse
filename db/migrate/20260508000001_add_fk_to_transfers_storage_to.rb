class AddFkToTransfersStorageTo < ActiveRecord::Migration[7.0]
  def change
    # Add foreign key constraint for existing storage_to_id column on transfers
    add_foreign_key :transfers, :storages, column: :storage_to_id
  end
end
