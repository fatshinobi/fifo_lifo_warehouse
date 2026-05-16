class StockMovementReportsController < Lintity::EntityReportController
  layout "application"

  def index
    start_time_value = params[:start_time].presence || 1.month.ago.beginning_of_day
    end_time_value = params[:end_time].presence || Time.current.end_of_day

    @entity_report_header_caption = "Stock Movement Report"
    @records = InventoryTransaction.stock_movement_calculation(
      storage_id: params[:storage_id],
      item_id: params[:item_id],
      start_time: start_time_value,
      end_time: end_time_value,
      fields_info: {
        items: { include: :item, field: :name },
        storages: { include: :storage, field: :name }
      }
    )
  end

  def new
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
