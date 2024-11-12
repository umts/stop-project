# frozen_string_literal: true

require 'csv'

class BusStop < ApplicationRecord
  has_paper_trail
  validates :name, presence: true
  validates :hastus_id, presence: true, uniqueness: { case_sensitive: false }
  has_many :bus_stops_routes, dependent: :destroy
  has_many :routes, through: :bus_stops_routes
  belongs_to :completed_by, optional: true, class_name: 'User',
                            foreign_key: :completed_by, inverse_of: :stops_completed

  before_save :assign_completion_timestamp, if: -> { completed_changed? }

  scope :not_updated_since, ->(date) { where(updated_at: ...date.to_datetime) }

  strings_required_for_completion = %i[name hastus_id bench curb_cut lighting
                                       mounting mounting_direction
                                       schedule_holder shelter sidewalk_width
                                       mounting_clearance created_at
                                       updated_at sign_type shelter_condition
                                       shelter_pad_condition has_power
                                       shelter_pad_material shelter_type
                                       garage_responsible bike_rack
                                       real_time_information needs_work
                                       obstructions stop_sticker
                                       route_stickers system_map_exists]

  boolean_required_for_completion = %i[bolt_on_base bus_pull_out_exists
                                       solar_lighting shelter_ada_compliant
                                       ada_landing_pad state_road accessible
                                       shared_sign_post_frta trash]

  validates(*strings_required_for_completion, presence: true, if: :completed?)
  validates(*boolean_required_for_completion, inclusion: { in: [true, false], message: :blank },
                                              if: :completed?)

  scope :completed, -> { where completed: true }
  scope :not_started, -> { where('created_at = updated_at').where(completed: [false, nil]) }
  scope :pending, -> { where('updated_at > created_at').where(completed: [false, nil]) }

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

  Options::COMBINED.each_value do |hash|
    hash.each do |name, options|
      validates name, inclusion: { in: options }, allow_blank: true if options.is_a?(Array)
    end
  end

  def to_param
    hastus_id
  end

  def last_updated
    versions.where(event: 'update').last
  end

  def last_updated_at
    if last_updated.present?
      last_updated.created_at.to_fs(:long_with_time)
    else
      'Unknown'
    end
  end

  def last_updated_by
    User.find_by(id: last_updated.try(:whodunnit)).try :name || 'Unknown'
  end

  def route_list
    routes.pluck(:number).uniq.sort.join(', ')
  end

  def self.search_names(text)
    where('LOWER(name) LIKE ?', "%#{text}%")
  end

  def self.to_csv(limited_attributes: false)
    attrs = if limited_attributes
              LIMITED_ATTRS
            else
              hashed_columns = columns.to_h { |c| [c.name, c.name.humanize] }
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
      find_each do |stop|
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

  def decide_if_completed_by(user)
    return unless completed_changed?

    assign_attributes(completed_by: (completed? ? user : nil))
  end

  def name_with_id
    "#{name} (#{hastus_id})"
  end

  private

  def assign_completion_timestamp
    assign_attributes completed_at: (completed? ? DateTime.current : nil)
  end
end
