class UpdateColumnTypesAndName < ActiveRecord::Migration[5.1]
  def change
    rename_column :bus_stops, :shelter_ada_compliance, :shelter_ada_compliant
    change_column :bus_stops, :has_power, :string
    change_column :bus_stops, :shared_sign_post, :boolean
    change_column :bus_stops, :system_map_exists, :string
    change_column :bus_stops, :trash, :boolean
  end
end
