<<<<<<< HEAD
class AddDescriptionToRoutes < ActiveRecord::Migration[5.1]
=======
class AddDescriptionToRoutes < ActiveRecord::Migration[4.2]
>>>>>>> c9726e8808c30c9a3f35e81b393f06d088a33726
  def change
    add_column :routes, :description, :string
  end
end
