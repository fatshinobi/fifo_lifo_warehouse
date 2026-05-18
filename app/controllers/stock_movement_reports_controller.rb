class StockMovementReportsController < Lintity::EntityReportController
  layout "application"

  def index
    start_time_value = params[:start_time].presence || 1.month.ago.beginning_of_day
    end_time_value = params[:end_time].presence || Time.current.end_of_day

    @entity_report_header_caption = "Stock Movement Report"

    # Build a description of the selected filters
    filter_parts = []
    if params[:storage_id].present?
      storage_name = Storage.find_by(id: params[:storage_id])&.name
      filter_parts << "Storage: #{storage_name}" if storage_name
    end
    if params[:item_id].present?
      item_name = Item.find_by(id: params[:item_id])&.name
      filter_parts << "Item: #{item_name}" if item_name
    end
    if params[:start_time].present?
      filter_parts << "Start time: #{params[:start_time]}"
    end
    if params[:end_time].present?
      filter_parts << "End time: #{params[:end_time]}"
    end
    @entity_filter_header_caption = "Filters: #{filter_parts.join(', ')}" if filter_parts.any?
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
