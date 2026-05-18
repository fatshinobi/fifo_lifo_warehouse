class BasicStockBalanceReportsController < Lintity::EntityReportController
  layout "application"

  # GET /basic_stock_balance_reports
  def index
    storage_id = params[:storage_id]
    item_id = params[:item_id]
    balance_time = params[:balance_time] || Time.current
    @records = InventoryTransaction.stock_balance_by_items_calculation(
      storage_id: storage_id,
      item_id: item_id,
      to_time: balance_time,
      fields_info: {
        items: { include: :item, field: :name },
        storages: { include: :storage, field: :name }
      }
    )
    # Construct filter description for header
    filter_parts = []
    if storage_id.present?
      storage_name = Storage.find_by(id: storage_id)&.name
      filter_parts << "Storage: #{storage_name}" if storage_name
    end
    if item_id.present?
      item_name = Item.find_by(id: item_id)&.name
      filter_parts << "Item: #{item_name}" if item_name
    end
    if params[:balance_time].present?
      filter_parts << "Balance time: #{params[:balance_time]}"
    end
    @entity_filter_header_caption = filter_parts.empty? ? "" : "Filters: #{filter_parts.join(', ')}"
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
