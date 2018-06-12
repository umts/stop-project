class AddDescriptionToRoutes < ActiveRecord::Migration[5.1]
  def change
    add_column :routes, :description, :string
  end
end
