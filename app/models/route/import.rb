# frozen_string_literal: true

class Route < ApplicationRecord
  class Import
    def initialize(source)
      @source = source
    end

    def import!
      @source.each_route do |route|
        Route.find_or_create_by!(number: route.short_name).tap do |r|
          r.update!(description: route.long_name)
        end
      end
    end
  end
end
