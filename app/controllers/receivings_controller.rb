class ReceivingsController < Lintity::EntityListController
  layout "application"

  # GET /receivings
  def index
    # Path for search helpers
    @search_path = receivings_path
    # Initialize records according to possible filter fields
    @records =
      if @filter_field
        Receiving.where("#{@filter_field} #{@filter_sign} ?", @filter_value.to_i)
      else
        Receiving.all
      end
    # Header caption and link to create new record
    @entity_list_header_caption, @entity_list_new_path = "Receivings List", new_receiving_path
    # No explicit render – the parent controller will handle the entity list view
  end

  # GET /receivings/new
  def new
    @receiving = Receiving.new
    # Build nested receiving_items for the form
    @receiving.receiving_items.build
  end

  # POST /receivings
  def create
    @receiving = Receiving.new(receiving_params)
      if @receiving.save
        # Trigger inventory processing when the receiving is in processed state
        ReceivingProcess.new(@receiving).call if @receiving.processed?
        redirect_to receivings_path, notice: "Receiving was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
  end

  # GET /receivings/:id/edit
  def edit
    @receiving = Receiving.find(params[:id])
  end

  # PATCH/PUT /receivings/:id
  def update
    @receiving = Receiving.find(params[:id])
      if @receiving.update(receiving_params)
        # Trigger inventory processing when the receiving is in processed state
        ReceivingProcess.new(@receiving).call if @receiving.processed?
        redirect_to receivings_path, notice: "Receiving was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
  end

  private

  # Define fields settings for the entity list according to project rules
  def init_fields
    @fields_settings = [
      { field: "formatted_id", name: "ID", type: "edit", path: Proc.new { |item_id| edit_receiving_path(id: item_id) } },
      { field: "storage_name", name: "Storage", type: "info" },
      { field: "formatted_received_at", name: "Received At", type: "info" }
    ]
  end

  def receiving_params
    params.require(:receiving).permit(
      :storage_id, :received_at, :stock_state,
      receiving_items_attributes: %i[id item_id qty cost _destroy]
    )
  end
end
