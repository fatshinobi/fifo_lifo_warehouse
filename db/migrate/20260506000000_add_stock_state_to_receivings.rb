class AddStockStateToReceivings < ActiveRecord::Migration[7.0]
  def change
    add_column :receivings, :stock_state, :integer, default: 0, null: false
  end
end
