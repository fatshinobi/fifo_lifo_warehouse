class CreateReceivings < ActiveRecord::Migration[8.1]
  def change
    create_table :receivings do |t|
      t.references :storage, null: false, foreign_key: true
      t.datetime :received_at

      t.timestamps
    end
  end
end
