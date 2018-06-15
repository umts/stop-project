class AddFieldNameToBusStopFields < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stop_fields, :field_name, :string
  end
end
