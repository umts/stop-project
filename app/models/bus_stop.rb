# frozen_string_literal: true

require 'csv'

class BusStop < ApplicationRecord
  include DateAndTimeMethods
  has_paper_trail
  validates :name, presence: true
  validates :hastus_id, presence: true, uniqueness: true
  has_and_belongs_to_many :routes
  has_many :bus_stop_fields
  has_many :fields, through: :bus_stop_fields

  before_save :assign_completion_timestamp, if: -> { completed_changed? }

  scope :not_updated_since,
        ->(date) { where 'updated_at < ?', date.to_datetime }

  SIGN_OPTIONS = {
    sign_type: ['Axehead (2014+)',
                'Rectangle (<2014)',
                'MGM + Axhead (2018+)'],
    mounting: ['PVTA pole',
               'Other pole',
               'City Pole',
               'Utility Pole',
               'Structure'],
    mounting_direction: ['Towards street',
                         'Away from street'],
    bolt_on_base: :boolean
  }.freeze

  SHELTER_OPTIONS = {
    shelter: %w[PVTA Other Building],
    shelter_condition: %w[Great Good Fair Poor],
    shelter_pad_condition: %w[Great Good Fair Poor],
    shelter_pad_material: %w[Asphalt Concrete Other]
  }.freeze

  AMENITIES = {
    bench: %w[PVTA Other],
    schedule_holder: ['On pole',
                      'In shelter'],
    system_map_exists: :boolean,
    trash: %w[PVTA Municipal Other]
  }.freeze

  ACCESSIBILITY = {
    accessible: ['When necessary',
                 'Not recommended'],
    curb_cut: ["Within 20'",
               'No curb cut',
               'No curb'],
    sidewalk: ['More than 36"',
               'Less than 36"',
               'None'],
    bus_pull_out_exists: :boolean

  }.freeze

  SECURITY_AND_SAFETY = {
    lighting: ["Within 20'",
               "20' - 50'",
               'None']
  }.freeze

  TECHNOLOGY = %i[solar_lighting has_power].freeze

  LIMITED_ATTRS = {
    name: 'Stop Name',
    hastus_id: 'Hastus ID',
    route_list: 'Routes',
    updated_at: 'Last updated'
  }.freeze

  SUPER_HASH = {
    sign_options: SIGN_OPTIONS,
    shelter_options: SHELTER_OPTIONS,
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
            else Hash[columns.map { |c| [c.name, c.name.humanize] }]
            end
    CSV.generate headers: true do |csv|
      csv << attrs.values
      all.each do |stop|
        csv << attrs.keys.map { |attr| stop.send attr }
      end
    end
  end

  private

  def assign_completion_timestamp
    assign_attributes completed_at: (completed? ? DateTime.current : nil)
  end
end
