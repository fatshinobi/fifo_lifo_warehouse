class AddLocationAndDescriptionToStorages < ActiveRecord::Migration[8.1]
  def change
    add_column :storages, :location, :string
    add_column :storages, :description, :text
  end
end
