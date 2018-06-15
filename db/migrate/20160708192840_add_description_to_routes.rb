class AddDescriptionToRoutes < ActiveRecord::Migration[4.2]
  def change
    add_column :routes, :description, :string
  end
end
