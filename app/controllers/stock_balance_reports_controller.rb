class StockBalanceReportsController < Lintity::EntityReportController
  layout "application"
  def index
    @records = InventoryTransaction.stock_balance_by_batches_calculation
    @entity_report_header_caption = "Stock Balance Report"
  end

  private

  def init_fields
    @fields_settings = [
      { field: "item", type: "info" },
      { field: "qty",  type: "number" },
      { field: "cost",  type: "number" }
    ]
  end
end
