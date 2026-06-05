class ItemsController < Lintity::EntityListController
  # GET /items
  layout "application"
  def index
    @search_path = items_path

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
    params.require(:item).permit(:name, :description, :cost, :method)
  end

  def init_fields
    @fields_settings = [
      { field: "name", name: "Name", type: "edit", path: Proc.new { |item_id| edit_item_path(id: item_id) } },
      { field: "description", name: "Description", type: "info" },
      { field: "method", name: "Inventory Method", type: "info" },
      { field: "cost", name: "Cost", type: "numeric_filter" }
    ]
  end

  def init_records
    @records =
      if @filter_field && valid_filter_field?
        Item.where(Item.arel_table[@filter_field].public_send(valid_filter_sign, @filter_value))
      else
        Item.all
      end
  end

  def valid_filter_field?
    @fields_settings.map { |f| f[:field] }.include?(@filter_field) && %(= <= >=).include?(@filter_sign)
  end

  def valid_filter_sign
    case @filter_sign
    when "="
      "eq"
    when "<="
      "lteq"
    when ">="
      "gteq"
    else
      nil
    end
  end
end
