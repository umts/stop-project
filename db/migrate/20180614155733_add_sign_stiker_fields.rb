class AddSignStikerFields < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stops, :stop_sticker, :string
    add_column :bus_stops, :route_stickers, :string
  end
end
