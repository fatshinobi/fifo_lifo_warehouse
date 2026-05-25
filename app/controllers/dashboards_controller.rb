class DashboardsController < ApplicationController
  def index
    # Fetch the last 10 records for each entity to display on the dashboard
    @receivings = Receiving.order(created_at: :desc).limit(10)
    @shipments  = Shipment.order(created_at: :desc).limit(10)
    @transfers  = Transfer.order(created_at: :desc).limit(10)
  end
end
