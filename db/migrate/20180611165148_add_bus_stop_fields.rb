class AddBusStopFields < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stops, :shared_sign_post, :string
    add_column :bus_stops, :shelter_ada_compliance, :boolean
    add_column :bus_stops, :garage_responsible, :string
    add_column :bus_stops, :date_stop_checked, :date
    add_column :bus_stops, :stop_checked_by, :string
    add_column :bus_stops, :bike_rack, :string
    add_column :bus_stops, :ada_landing_pad, :boolean
    add_column :bus_stops, :real_time_information, :string
    add_column :bus_stops, :state_road, :boolean
    add_column :bus_stops, :need_work, :integer
    add_column :bus_stops, :obstructions, :string
    add_column :bus_stops, :accessible, :boolean
  end
end
