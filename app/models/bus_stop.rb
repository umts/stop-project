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

  before_save :assign_completion_timestamp, if: -> { completed_changed? }

  scope :not_updated_since,
        ->(date) { where 'updated_at < ?', date.to_datetime }

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
    CSV.generate headers: true do |csv|
      all_field_names = Field.pluck :name
      stop_attrs = { name: 'Stop Name', hastus_id: 'Hastus ID', route_list: 'Routes', updated_at: 'Last updated' }
      csv << stop_attrs.values + all_field_names
      all.each do |stop|
        stop_data = stop_attrs.keys.map { |attr| stop.send attr }
        all_field_names.each do |field_name|
          bsf = BusStopField.find_by(bus_stop: stop, field_name: field_name)
          stop_data << bsf.send(:value) if bsf.present?
        end
        csv << stop_data
      end
    end
  end

  private

  def assign_completion_timestamp
    assign_attributes completed_at: (completed? ? DateTime.current : nil)
  end
end
