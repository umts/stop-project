class BusStop < ActiveRecord::Base
  validates :name, :hastus_id, presence: true
  default_scope -> { order :name }
end
