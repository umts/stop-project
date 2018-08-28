class BusStopField < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :field, foreign_key: :field_name
  
  validate :check_choice_included
  validates_uniqueness_of :field_name, scope: :bus_stop_id
  
  private
    def check_choice_included
      if field.multiple_choice? && !field.choices.include?(value)
        errors.add :value, 'is not a valid choice for this field'
      end
    end
end
