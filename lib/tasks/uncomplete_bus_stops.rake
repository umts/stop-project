# frozen_string_literal: true

namespace :bus_stops do
  desc 'Mark all stops as incomplete'
  task uncomplete_all: :environment do
    # Yes, it skips validations, but marking a stop as incomplete means someone
    # is going to update it (and face validations) in the future before it's
    # exported anyways.
    # rubocop:disable Rails/SkipsModelValidations
    BusStop.update_all completed: false
    # rubocop:enable Rails/SkipsModelValidations
  end
end
