class ChangeBusstopFieldType < ActiveRecord::Migration[5.1]
  def change
    change_column :bus_stops, :need_work, :string
  end
end
