# frozen_string_literal: true

require 'csv'

class BusStop < ApplicationRecord
  include DateAndTimeMethods
  has_paper_trail
  validates :name, presence: true
  validates :hastus_id, presence: true, uniqueness: true
  has_many :bus_stops_routes
  has_many :routes, through: :bus_stops_routes
  belongs_to :completed_by, class_name: 'User', foreign_key: :completed_by

  before_save :assign_completion_timestamp, if: -> { completed_changed? }

  scope :not_updated_since,
        ->(date) { where 'updated_at < ?', date.to_datetime }
  strings_required_for_completion = %i[name hastus_id bench curb_cut lighting
                                       mounting mounting_direction
                                       schedule_holder shelter sidewalk_width
                                       trash mounting_clearance created_at
                                       updated_at sign_type shelter_condition
                                       shelter_pad_condition
                                       shelter_pad_material shelter_type
                                       shared_sign_post garage_responsible
                                       bike_rack real_time_information
                                       need_work obstructions stop_sticker
                                       route_stickers]

  boolean_required_for_completion = %i[bolt_on_base bus_pull_out_exists
                                       has_power solar_lighting
                                       system_map_exists shelter_ada_compliance
                                       ada_landing_pad state_road accessible]

  validates *strings_required_for_completion, presence: true, if: :completed?
  validates *boolean_required_for_completion,
            inclusion: {
                in: [true, false],
                message: "can't be blank"
            }, if: :completed?

  scope :completed, -> { where completed: true }
  scope :not_started, lambda {
    (where 'created_at = updated_at')
      .where completed: [false, nil]
  }
  scope :pending, lambda {
    (where 'updated_at > created_at')
      .where completed: [false, nil]
  }

  SIGN_OPTIONS = {
    sign_type: ['Axehead (2014+)',
                'Rectangle (<2014)',
                'MGM + Axhead (2018+)',
                'Other',
                'No sign'],
    mounting: ['PVTA pole',
               'Other pole',
               'City pole',
               'Utility pole',
               'Structure',
               'No sign'],
    shared_sign_post: ['No',
                       'Yes - Traffic sign',
                       'Yes - FRTA',
                       'Yes - Other',
                       'Sign not on pole'],
    mounting_direction: ['Towards street',
                         'Away from street',
                         'Center',
                         'No sign'],
    mounting_clearance: ['Less than 60 inches',
                         '60-83 inches',
                         'Greater than 84 inches',
                         'No sign'],
    bolt_on_base: :boolean,
    stop_sticker: ['No sticker',
                   'Sticker incorrect',
                   'Sticker correct'],
    route_stickers: ['No stickers',
                     'Stickers incorrect',
                     'Stickers correct']
  }.freeze

  SHELTER_OPTIONS = {
    shelter: ['No shelter',
              'PVTA shelter',
              'Other',
              'Building'],
    shelter_type: ['Modern',
                   'Modern half',
                   'Victorian',
                   'Dome',
                   'Wooden',
                   'Extra large',
                   'Other',
                   'No shelter'],
    shelter_ada_compliance: :boolean,
    shelter_condition: ['Great',
                        'Good',
                        'Fair',
                        'Poor',
                        'No shelter'],
    shelter_pad_condition: ['Great',
                            'Good',
                            'Fair',
                            'Poor',
                            'No shelter'],
    shelter_pad_material: ['Asphalt',
                           'Concrete',
                           'Other',
                           'No shelter']
  }.freeze

  AMENITIES = {
    bench: ['PVTA bench',
            'Other bench',
            'Other structure',
            'None'],
    bike_rack: ['PVTA bike rack',
                'Other bike rack',
                'Bike locker',
                'None'],
    schedule_holder: ['On pole',
                      'In shelter',
                      'None'],
    system_map_exists: :boolean,
    trash: %w[PVTA Municipal Other None]
  }.freeze

  ACCESSIBILITY = {
    accessible: :boolean,
    curb_cut: ['Within 20 feet',
               '20 - 50 feet ',
               'No curb cut',
               'No curb'],
    sidewalk_width: ['More than 36 inches',
                     'Less than 36 inches',
                     'None'],
    bus_pull_out_exists: :boolean,
    ada_landing_pad: :boolean,
    obstructions: ['Yes - Tree/Branch',
                   'Yes - Bollard/Structure',
                   'Yes - Parking',
                   'Yes - Other',
                   'No']

  }.freeze

  SECURITY_AND_SAFETY = {
    lighting: ['Within 20 feet',
               '20 - 50 feet',
               'None']
  }.freeze

  TECHNOLOGY = { solar_lighting: :boolean,
                 has_power: :boolean,
                 real_time_information: ['Yes - Solar',
                                         'Yes - Power',
                                         'No']
  }.freeze

  LIMITED_ATTRS = {
    name: 'Stop Name',
    id: 'Id',
    hastus_id: 'Hastus ID',
    route_list: 'Routes',
    created_at: 'Created at',
    updated_at: 'Last updated',
    last_updated_by: 'Last updated by',
    completed: 'Completed',
    completed_by: 'Completed by',
    completed_at: 'Completed at'
  }.freeze

  SUPER_HASH = {
    sign: SIGN_OPTIONS,
    shelter: SHELTER_OPTIONS,
    amenities: AMENITIES,
    accessibility: ACCESSIBILITY,
    security_and_safety: SECURITY_AND_SAFETY,
    technology: TECHNOLOGY
  }.freeze

  SUPER_HASH.each do |hash|
    hash.each do |name, options|
      if options.kind_of?(Array)
        validates name, inclusion: { in: options }, allow_blank: true
      end
    end
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

  def self.to_csv(limited_attributes: false)
    attrs = if limited_attributes
              LIMITED_ATTRS
            else
              hashed_columns = Hash[columns.map { |c| [c.name, c.name.humanize] }]
                               .except('name',
                                       'hastus_id',
                                       'id',
                                       'updated_at',
                                       'created_at',
                                       'route_list',
                                       'completed_at',
                                       'completed_by',
                                       'completed')
              LIMITED_ATTRS.merge hashed_columns
            end
    CSV.generate headers: true do |csv|
      csv << attrs.values
      all.each do |stop|
        csv << attrs.keys.map do |attr|
          stop.send attr
        end
      end
    end
  end

  def decide_if_completed_by(user)
    if completed_changed?
      assign_attributes(completed_by: (completed? ? user : nil))
    end
  end

  private

  def assign_completion_timestamp
    assign_attributes completed_at: (completed? ? DateTime.current : nil)
  end
end
