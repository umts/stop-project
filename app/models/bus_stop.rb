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
                                       mounting_clearance created_at
                                       updated_at sign_type shelter_condition
                                       shelter_pad_condition has_power
                                       shelter_pad_material shelter_type
                                       garage_responsible bike_rack
                                       real_time_information need_work
                                       obstructions stop_sticker
                                       route_stickers system_map_exists]

  boolean_required_for_completion = %i[bolt_on_base bus_pull_out_exists
                                       solar_lighting shelter_ada_compliant
                                       ada_landing_pad state_road accessible
                                       shared_sign_post_frta trash]

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
    sign_type: ['Axehead',
                'Rectangle',
                'MGM and Axehead',
                'Other',
                'Non PVTA'],
    mounting: ['PVTA pole',
               'City pole',
               'Utility pole',
               'Structure',
               'No sign'],
    shared_sign_post_frta: :boolean,
    mounting_direction: ['Towards street',
                         'Away from street',
                         'Center',
                         'No sign'],
    mounting_clearance: ['Less than 60 inches',
                         '60-84 inches',
                         'Greater than 84 inches',
                         'No sign face'],
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
              'Other shelter',
              'Nearby building'],
    shelter_type: ['Modern full',
                   'Modern half',
                   'Victorian',
                   'Dome',
                   'Wooden',
                   'Extra large',
                   'Other',
                   'No shelter'],
    shelter_ada_compliant: :boolean,
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
            'PVTA and other bench',
            'None'],
    bike_rack: ['PVTA bike rack',
                'Other bike rack',
                'PVTA and other bike rack',
                'None'],
    schedule_holder: ['On pole',
                      'In shelter',
                      'None'],
    system_map_exists: ['New map',
                        'Old map',
                        'No map'],
    trash: :boolean
  }.freeze

  ACCESSIBILITY = {
    accessible: :boolean,
    curb_cut: ['Within 20 feet',
               'No curb cut',
               'No curb'],
    sidewalk_width: ['More than 36 inches',
                     'Less than 36 inches',
                     'None'],
    bus_pull_out_exists: :boolean,
    ada_landing_pad: :boolean,
    obstructions: ['Yes - Tree/Branch',
                   'Yes - Bollard/Structure',
                   'Yes - Sign/Post',
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
                 has_power: ['Yes - Stub up',
                             'Yes - Outlet',
                             'No'],
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
    routes.pluck(:number).uniq.sort.join(', ')
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
          if attr == :completed_by
            stop.completed_by.try(:name)
          else
            stop.send attr
          end
        end
      end
    end
  end

  def self.to_hastus_xml
    Nokogiri::XML::Builder.new do |doc|
      doc.data do
        all.each do |stop|
          doc.stop do
            doc.stp_identifier                    stop.hastus_id
            doc.stp_ud_accessible_when_necessary  stop.accessible == 'When necessary'
            doc.stp_ud_accessible_not_recommended stop.accessible == 'Not recommended'
            doc.stp_ud_bench_pvta_bench           stop.bench == 'PVTA'
            doc.stp_ud_bench_other_bench          stop.bench == 'Other'
            doc.stp_ud_curb_cut_drive_within_20ft stop.curb_cut == "Within 20'"
            doc.stp_ud_curb_cut_no_curb_cut       stop.curb_cut == 'No curb cut'
            doc.stp_ud_curb_cut_no_curb           stop.curb_cut == 'No curb'
            doc.stp_ud_lighting_solar             stop.solar_lighting?
            doc.stp_ud_lighting_within_20ft       stop.lighting == "Within 20'"
            doc.stp_ud_lighting_within_50ft       stop.lighting == "Within 50'"
            doc.stp_ud_lighting_no_lighting       stop.lighting == 'None'
            doc.stp_ud_mounting_pvta_pole         stop.mounting == 'PVTA pole'
            doc.stp_ud_mounting_pole_other        stop.mounting == 'Other pole'
            doc.stp_ud_mounting_structure         stop.mounting == 'Structure'
            doc.stp_ud_schedule_holder_on_pole    stop.schedule_holder == 'On pole'
            doc.stp_ud_schedule_holder_in_shelter stop.schedule_holder == 'In shelter'
            doc.stp_ud_shelter_pvta               stop.shelter == 'PVTA'
            doc.stp_ud_shelter_other              stop.shelter == 'Other'
            doc.stp_ud_shelter_building           stop.shelter == 'Building'
            doc.stp_ud_sidewalk_more_than_36in    stop.sidewalk_width == "More than 36'"
            doc.stp_ud_sidewalk_less_than_36in    stop.sidewalk_width == "Less than 36'"
            doc.stp_ud_sidewalk_no_sidewalk       stop.sidewalk_width == 'None'
            doc.stp_ud_system_map                 stop.system_map_exists?
            doc.stp_ud_trash_pvta                 stop.trash == 'PVTA'
            doc.stp_ud_trash_municipal            stop.trash == 'Municipal'
            doc.stp_ud_trash_other                stop.trash == 'Other'
          end
        end
      end
    end.to_xml
  end

  def decide_if_completed_by(user)
    if completed_changed?
      assign_attributes(completed_by: (completed? ? user : nil))
    end
  end

  def name_with_id
    "#{name} (#{hastus_id})"
  end

  def self.strip_id_from_name(name_with_id)
    name_with_id[/[^(]+/].strip
  end

  private

  def assign_completion_timestamp
    assign_attributes completed_at: (completed? ? DateTime.current : nil)
  end
end
