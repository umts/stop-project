class AddChoicesToField < ActiveRecord::Migration[5.1]
  def change
    add_column :fields, :choices, :text
  end
end
