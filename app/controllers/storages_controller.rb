class StoragesController < Lintity::EntityListController
  # GET /storages
  layout "application"

  def index
    @search_path = storages_path
    @records =
      if @filter_field
        Storage.where("#{@filter_field} #{@filter_sign} ?", @filter_value.to_i)
      else
        Storage.all
      end
    super
  end

  # GET /storages/new
  def new
    @storage = Storage.new
  end

  # POST /storages
  def create
    @storage = Storage.new(storage_params)
    if @storage.save
      redirect_to storages_path, notice: "Storage was successfully created."
    else
      render :new
    end
  end

  # GET /storages/:id/edit
  def edit
    @storage = Storage.find(params[:id])
  end

  # PATCH/PUT /storages/:id
  def update
    @storage = Storage.find(params[:id])
    if @storage.update(storage_params)
      redirect_to storages_path, notice: "Storage was successfully updated."
    else
      render :edit
    end
  end

  private

  def storage_params
    params.require(:storage).permit(:name, :location, :capacity)
  end

  def init_fields
    @fields_settings = [
      { field: "name", name: "Name", type: "edit", path: Proc.new { |storage_id| edit_storage_path(id: storage_id) } }
    ]
  end
end
