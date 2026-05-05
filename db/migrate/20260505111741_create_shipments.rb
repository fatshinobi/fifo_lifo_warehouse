class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.references :storage, null: false, foreign_key: true
      t.datetime :shipped_at

      t.timestamps
    end
  end
end
