class StockMovementReportsController < Lintity::EntityReportController
  layout "application"

  def index
    init_fields
    @entity_report_header_caption = "Stock Movement Report"
    @records = InventoryTransaction.stock_movement_calculation(
      storage_id: params[:storage_id],
      item_id: params[:item_id],
      fields_info: {
        items: { include: :item, field: :name },
        storages: { include: :storage, field: :name }
      }
    )
  end

  def new
    init_fields
    @items = Item.all
    @storages = Storage.all
  end

  private

  def init_fields
    @fields_settings = [
      { field: "item", type: "info" },
      { field: "qty", type: "number" },
      { field: "cost", type: "info" }
    ]
  end
end
