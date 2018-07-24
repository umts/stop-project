class ChangeBusstopFieldType < ActiveRecord::Migration[5.1]
  def change
    change_column :bus_stops, :need_work, :string
    change_column :bus_stops, :mounting_clearance, :string
  end
end
