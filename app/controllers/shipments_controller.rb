class ShipmentsController < Lintity::EntityListController
  layout "application"

  # GET /shipments
  def index
    @search_path = shipments_path
    @records =
      if @filter_field
        Shipment.where("#{@filter_field} #{@filter_sign} ?", @filter_value.to_i)
      else
        Shipment.all
      end

    @entity_list_header_caption, @entity_list_new_path = "Shipments List", new_shipment_path
  end

  # GET /shipments/new
  def new
    @shipment = Shipment.new
    # build a default shipment_item for the form if needed
    @shipment.shipment_items.build
  end

  # POST /shipments
  def create
    @shipment = Shipment.new(shipment_params)
    if @shipment.save
      redirect_to shipments_path, notice: "Shipment was successfully created."
    else
      render :new
    end
  end

  # GET /shipments/:id/edit
  def edit
    @shipment = Shipment.find(params[:id])
  end

  # PATCH/PUT /shipments/:id
  def update
    @shipment = Shipment.find(params[:id])
    if @shipment.update(shipment_params)
      redirect_to shipments_path, notice: "Shipment was successfully updated."
    else
      render :edit
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(
      :shipped_at,
      :storage_id,
      shipment_items_attributes: [ :id, :item_id, :qty, :price, :_destroy ]
    )
  end

  # Define fields for the entity list view as required by .roo rules
  def init_fields
    @fields_settings = [
      { field: "formatted_id", name: "ID", type: "edit", path: Proc.new { |id| edit_shipment_path(id: id) } },
      { field: "storage_name", name: "Storage", type: "info" },
      { field: "formatted_shipped_at", name: "Shipped At", type: "info" }
    ]
  end
end
