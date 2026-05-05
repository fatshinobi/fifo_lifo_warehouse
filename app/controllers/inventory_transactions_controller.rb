class InventoryTransactionsController < Lintity::EntityListController
  layout "application"

  def index
    @search_path = inventory_transactions_path
    @records =
      if @filter_field
        InventoryTransaction.where("#{@filter_field} #{@filter_sign} ?", @filter_value.to_i)
      else
        InventoryTransaction.all
      end
    @entity_list_header_caption, @entity_list_new_path = "Inventory Transactions List", nil
    init_fields
  end

  private

  def init_fields
    @fields_settings = [
      { field: "formatted_transaction_time", name: "Transaction Time", type: "info" },
      { field: "batch_number", name: "Batch", type: "info" },
      { field: "storage_name", name: "Storage", type: "info" },
      { field: "item_name", name: "Item", type: "info" },
      { field: "qty", name: "Qty", type: "info" },
      { field: "cost", name: "Cost", type: "info" }
    ]
  end
end
