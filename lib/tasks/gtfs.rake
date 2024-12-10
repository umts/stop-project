# frozen_string_literal: true

require 'gtfs'

module GTFSSource
  def self.with_default(args)
    source = args[:source] || 'https://pvta.com/g_trans/google_transit.zip'
    GTFS::Source.build(source)
  end
end

namespace :gtfs do
  desc 'Import GTFS routes - pass a path or URL to the GTFS zip file'
  task :import_routes, [:source] => [:environment] do |_, args|
    Route::Import.new(GTFSSource.with_default(args)).import!
  end

  desc 'Import GTFS stops - pass a path or URL to the GTFS zip file'
  task :import_stops, [:source] => [:environment] do |_, args|
    BusStop::Import.new(GTFSSource.with_default(args)).import!
  end

  desc 'Import GTFS trips - pass a path or URL to the GTFS zip file'
  task :import_trips, [:source] => [:environment] do |_, args|
    BusStopsRoute::Import.new(GTFSSource.with_default(args)).import!
  end
end
