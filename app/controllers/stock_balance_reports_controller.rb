class StockBalanceReportsController < Lintity::EntityReportController
  layout "application"
  before_action :set_entity_filter_header, only: [ :index ]
  def index
    storage_id = params[:storage_id]
    item_id = params[:item_id]
    balance_time = params[:balance_time] || Time.current
    @records = InventoryTransaction.stock_balance_by_batches_calculation(
      storage_id: storage_id,
      item_id: item_id,
      to_time: balance_time,
      fields_info: {
        items: { include: :item, field: :name },
        storages: { include: :storage, field: :name }
      }
    )

    # @entity_filter_header_caption is now set by before_action

    @entity_report_header_caption, @entity_report_pdf_path = "Stock Balance Report", stock_balance_reports_path(format: :pdf, storage_id: storage_id, item_id: item_id, balance_time: balance_time)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "stock_balance_report_#{Time.current.to_i}", # The name of the downloaded file
                template: 'lintity/entity_report/index',
                layout: "layouts/pdf", # Optional: Use a specific layout
                disposition: 'attachment' # Optional: Force download instead of inline view

      end
    end
  end

  # Show a form to select an Item and a Storage before displaying the report
  def new
    @items = Item.all
    @storages = Storage.all
  end

  private

  def set_entity_filter_header
    filter_parts = []
    if params[:storage_id].present?
      storage_name = Storage.find_by(id: params[:storage_id])&.name
      filter_parts << "Storage: #{storage_name}" if storage_name.present?
    end
    if params[:item_id].present?
      item_name = Item.find_by(id: params[:item_id])&.name
      filter_parts << "Item: #{item_name}" if item_name.present?
    end
    if params[:balance_time].present?
      filter_parts << "Balance time: #{params[:balance_time]}"
    end
    @entity_filter_header_caption = "Filters: #{filter_parts.join(', ')}" if filter_parts.present?
  end

  def init_fields
    @fields_settings = [
      { field: "item", type: "info" },
      { field: "qty",  type: "number" },
      { field: "cost",  type: "number" }
    ]
  end
end
