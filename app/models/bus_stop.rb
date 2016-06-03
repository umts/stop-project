class BusStop < ActiveRecord::Base
  has_paper_trail
  validates :name, :hastus_id, presence: true
  default_scope -> { order :name }
end
