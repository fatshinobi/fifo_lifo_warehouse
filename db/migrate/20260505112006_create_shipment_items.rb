class CreateShipmentItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shipment_items do |t|
      t.references :shipment, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :qty
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
