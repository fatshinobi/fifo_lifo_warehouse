class CreateTransferItems < ActiveRecord::Migration[8.1]
  def change
    create_table :transfer_items do |t|
      t.references :transfer, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :qty

      t.timestamps
    end
  end
end
