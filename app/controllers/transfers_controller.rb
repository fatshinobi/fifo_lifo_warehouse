class TransfersController < Lintity::EntityListController
  layout "application"

  # GET /transfers
  def index
    @search_path = transfers_path
    @records = if @filter_field
      Transfer.where("#{@filter_field} #{@filter_sign} ?", @filter_value.to_i)
    else
      Transfer.all
    end
    @entity_list_header_caption, @entity_list_new_path = "Transfers List", new_transfer_path
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
    @transfer.transfer_items.build
  end

  # POST /transfers
  def create
    @transfer = Transfer.new(transfer_params)
    if @transfer.save
      # Trigger TransferProcess when stock_state changes (e.g., from draft to processed)
      if @transfer.saved_change_to_stock_state?
        TransferProcess.new(@transfer).call
      end
      redirect_to transfers_path, notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /transfers/:id/edit
  def edit
    @transfer = Transfer.find(params[:id])
  end

  # PATCH/PUT /transfers/:id
  def update
    @transfer = Transfer.find(params[:id])
    if @transfer.update(transfer_params)
      # Trigger TransferProcess if stock_state was changed during the update
      if @transfer.saved_change_to_stock_state?
        TransferProcess.new(@transfer).call
      end
      redirect_to transfers_path, notice: "Transfer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def init_fields
    @fields_settings = [
      { field: "formatted_id", name: "ID", type: "edit", path: Proc.new { |id| edit_transfer_path(id: id) } },
      { field: "storage_name", name: "Source", type: "info" },
      { field: "storage_to_name", name: "Destination", type: "info" },
      { field: "formatted_transferred_at", name: "Transferred At", type: "info" }
    ]
  end

  def transfer_params
    params.require(:transfer).permit(
      :storage_id,
      :storage_to_id,
      :transferred_at,
      :stock_state,
      transfer_items_attributes: [ :id, :item_id, :qty, :_destroy ]
    )
  end
end
