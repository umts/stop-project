class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields, id: false do |t|
      t.string :name
      t.string :category
      t.text :description
      t.integer :rank
      t.string :field_type
      t.text :choices
    end
    add_index :fields, :name
  end
end
