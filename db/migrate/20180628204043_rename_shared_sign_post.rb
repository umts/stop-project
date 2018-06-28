class RenameSharedSignPost < ActiveRecord::Migration[5.1]
  def change
    rename_column :bus_stops, :shared_sign_post, :shared_sign_post_frta
  end
end
