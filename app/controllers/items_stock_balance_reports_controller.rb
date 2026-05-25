class ItemsStockBalanceReportsController < Lintity::EntityReportController
  layout "application"

  before_action :set_entity_filter_header, only: [ :index ]

  def new
    @items = Item.all
  end

  def index
    @search_path = items_stock_balance_reports_path
    @entity_report_header_caption = "Items Stock Balance Report"

    @item_id = params[:item_id]
    @balance_time = params[:balance_time]

    @records = InventoryTransaction.stock_balance_for_items_calculation(
      item_id: @item_id,
      to_time: @balance_time,
      fields_info: {
        items: { include: :item, field: :name }
      }
    )
  end

  private

  def init_fields
    @fields_settings = [
      { field: "item", type: "info" },
      { field: "balance_time", type: "datetime" },
      { field: "qty", type: "number" },
      { field: "cost", type: "number" }
    ]
  end

  def set_entity_filter_header
    filter_parts = []
    if params[:item_id].present?
      item_name = Item.find_by(id: params[:item_id])&.name
      filter_parts << "Item: #{item_name}" if item_name
    end
    if params[:balance_time].present?
      filter_parts << "Balance time: #{params[:balance_time]}"
    end
    @entity_filter_header_caption = "Filters: #{filter_parts.join(', ')}" if filter_parts.present?
  end
end
