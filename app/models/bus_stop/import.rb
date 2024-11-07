# frozen_string_literal: true

class BusStop < ApplicationRecord
  class Import
    def initialize(source)
      @source = source
    end

    def import!
      @source.each_stop do |stop|
        next if stop.location_type.present? && stop.location_type != '0'

        BusStop.create_with(name: stop.name).find_or_create_by!(hastus_id: stop.id).tap do |s|
          s.update! name: stop.name
        end
      end
    end
  end
end
