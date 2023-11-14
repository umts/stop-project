# frozen_string_literal: true

namespace :bus_stops do
  desc 'Update other sign types to no sign'
  task update_sign_type: :environment do
    BusStop.where(sign_type: 'Other').each do |stop|
      stop.update sign_type: 'No sign'
    end
  end
end
