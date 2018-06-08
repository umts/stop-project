class ChangeHastusIdToString < ActiveRecord::Migration[4.2]
  def up
    change_column :bus_stops, :hastus_id, :string
  end

  def down
    change_column :bus_stops, :hastus_id, :integer
  end
end
