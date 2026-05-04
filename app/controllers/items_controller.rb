class ItemsController < Lintity::EntityListController
  # GET /items
  layout "application"
  def index
    @search_path = items_path
    @records =
      if @filter_field
        Item.where("#{@filter_field} #{@filter_sign} ?", @filter_value.to_i)
      else
        Item.all
      end

    @entity_list_header_caption, @entity_list_new_path = "Items List", new_item_path
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path, notice: "Item was successfully created."
    else
      render :new
    end
  end

  # GET /items/:id/edit
  def edit
    @item = Item.find(params[:id])
  end

  # PATCH/PUT /items/:id
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to items_path, notice: "Item was successfully updated."
    else
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :cost)
  end

  def init_fields
    @fields_settings = [
      { field: "name", name: "Name", type: "edit", path: Proc.new { |item_id| edit_item_path(id: item_id) } },
      { field: "description", name: "Description", type: "info" },
      { field: "cost", name: "Cost", type: "numeric_filter" }
    ]
  end
end
