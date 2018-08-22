# frozen_string_literal: true

require 'csv'
include DateAndTimeMethods

class BusStop < ApplicationRecord
  has_paper_trail

  has_and_belongs_to_many :routes
  has_many :bus_stop_fields, dependent: :destroy
  has_many :fields, through: :bus_stop_fields

  accepts_nested_attributes_for :bus_stop_fields

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

  def data_fields
    Field.categories.map do |category|
      category_fields = Field.in_category(category).order(:rank).map do |field|
        BusStopField.where(field: field, bus_stop: self).first_or_create
      end
      [category, category_fields]
    end.to_h
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

  def self.to_csv
    CSV.generate do |csv|
      # want BSFs that exist but don't have matching fields, too.
      all_field_names = BusStopField.pluck(:field_name).uniq
      stop_attrs = { name: 'Stop Name', hastus_id: 'Hastus ID', route_list: 'Routes', updated_at: 'Last updated' }
      csv << stop_attrs.values + all_field_names
      all.each do |stop|
        stop_data = stop_attrs.keys.map { |attr| stop.send attr }
        all_field_names.each do |field_name|
          bsf = BusStopField.find_by(bus_stop: stop, field_name: field_name)
          stop_data << bsf.value if bsf.present?
        end
        csv << stop_data
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
