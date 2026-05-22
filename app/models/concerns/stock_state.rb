module StockState
  extend ActiveSupport::Concern

  included do
    # Shared enum for stock state across models
    enum :stock_state, { draft: 0, processed: 1, recalculating: 2 }
  end
end
