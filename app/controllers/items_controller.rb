class ItemsController < ApplicationController
  # GET /items
  def index
    @items = Item.all
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
end
