include DateAndTimeMethods

class BusStop < ApplicationRecord
  has_paper_trail
  validates :name, presence: true
  validates :hastus_id, presence: true, uniqueness: true
  has_and_belongs_to_many :routes

  before_save :assign_completion_timestamp, if: -> { completed_changed? }

  scope :not_updated_since, -> (date) { where 'updated_at < ?', date.to_datetime }

  STRING_COLUMN_OPTIONS = {
    accessible: ['When necessary', 'Not recommended'],
    bench: %w[PVTA Other],
    curb_cut: ["Within 20'", 'No curb cut', 'No curb'],
    lighting: ["Within 20'", "20' - 50'", 'None'],
    mounting: ['PVTA pole', 'Other pole', 'City Pole', 'Utility Pole', 'Structure'],
    mounting_direction: ['Towards street', 'Away from street'],
    schedule_holder: ['On pole', 'In shelter'],
    shelter: %w[PVTA Other Building],
    shelter_condition: %w[Great Good Fair Poor],
    shelter_pad_condition: %w[Great Good Fair Poor],
    shelter_pad_material: %w[Asphalt Concrete Other],
    shelter_type: %w[Modern Modern\ half Victorian Dome Wooden Extra\ large Other],
    sidewalk: ['More than 36"', 'Less than 36"', 'None'],
    sign: ['Flag stop', 'Missing sign', 'Needs attention'],
    sign_type: ['Axehead (2014+)', 'Rectangle (<2014)', 'MGM + Axhead (2018+)'],
    trash: %w[PVTA Municipal Other],
  }

  BOOLEAN_COLUMNS = %i(bolt_on_base bus_pull_out_exists extend_pole has_power
    new_anchor new_pole solar_lighting straighten_pole system_map_exists)

  STRING_COLUMN_OPTIONS.each do |attribute, options|
    validates attribute, inclusion: { in: options }, allow_blank: true
  end

  def last_updated
    versions.where(event: 'update').last
  end

  def last_updated_at
    if last_updated.present?
      format_datetime last_updated.created_at
    else 'Unknown'
    end
  end

  def last_updated_by
    User.find_by(id: last_updated.try(:whodunnit)).try :name || 'Unknown'
  end

  def route_list
    routes.pluck(:number).sort.join(', ')
  end

  private

  def assign_completion_timestamp
    assign_attributes completed_at: (completed? ? DateTime.current : nil)
  end

end
