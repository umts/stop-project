# frozen_string_literal: true

module FieldFixes
  FIELD_MAP = {
    sign_type: {
      "Axehead (2014+)" => "Axehead",
      "Rectangle (<2014)" => "Rectangle",
      "MGM + Axhead (2018+)" => "MGM and Axehead"
    },
    mounting: {
      "Other pole" => nil,
      "City Pole" => "City pole"
    },
    mounting_clearance: {
      "60-83 inches" => "60-84 inches",
      "No sign" => "No sign face"
    },
    shelter: {
      "Building" => "Nearby building",
      "PVTA" => "PVTA shelter",
      "Other" => "Other shelter"
    },
    shelter_type: {
      "Modern" => 'Modern full'
    },
    bench: {
      "PVTA" => "PVTA bench",
      "Other" => "Other bench"
    },
    bike_rack: {
      "Bike locker" => nil
    },
    curb_cut: {
      "Within 20'" => "Within 20 feet",
      "20 - 50 feet " => "No curb cut"
    },
    sidewalk_width: {
      'More than 36"' => "More than 36 inches",
      'Less than 36"' => "Less than 36 inches"
    },
    lighting: {
      "Within 20'" => "Within 20 feet",
      "20' - 50'" => "20 - 50 feet"
    }
  }
end

namespace :bus_stops do
  desc 'Fix invalid pseudo-enums'
  task reconcile_fields: :environment do
    BusStop.find_each do |stop|
      FieldFixes::FIELD_MAP.each do |field, map|
        if map.key? stop.send(field)
          new_value = map.fetch stop.send(field)
          stop.send "#{field}=", new_value
          stop.completed = false if new_value.nil?
        end
      end
      stop.save!
    end
  end
end
