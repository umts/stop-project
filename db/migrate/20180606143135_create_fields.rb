class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :name
      t.string :category
      t.text :description
      t.integer :rank
      t.string :field_type

      t.timestamps
    end
  end
end
