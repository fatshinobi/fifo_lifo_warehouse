class BasicStockBalanceReportsController < Lintity::EntityReportController
  layout "application"

  # GET /basic_stock_balance_reports
  def index
    storage_id = params[:storage_id]
    item_id = params[:item_id]
    @records = InventoryTransaction.stock_balance_by_items_calculation(
      storage_id: storage_id,
      item_id: item_id,
      fields_info: {
        items: { include: :item, field: :name },
        storages: { include: :storage, field: :name }
      }
    )
    @entity_report_header_caption = "Basic Stock Balance Report"
  end

  # GET /basic_stock_balance_reports/new
  def new
    @items = Item.all
    @storages = Storage.all
  end

  private

  def init_fields
    @fields_settings = [
      { field: "item", type: "info" },
      { field: "qty", type: "number" },
      { field: "cost", type: "number" }
    ]
  end
end
