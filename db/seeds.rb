# frozen_string_literal: true

require 'timecop'

FactoryBot.create :user, name: 'Admin User', email: 'admin@example.com', admin: true
FactoryBot.create :user, name: 'Non-Admin User', email: 'user@example.com', admin: false

routes = {
  30 => Route.create!(number: '30', description: 'North Amherst / Old Belchertown Rd'),
  31 => Route.create!(number: '31', description: 'Sunderland / South Amherst'),
  38 => Route.create!(number: '38', description: 'UMass / Mount Holyoke College')
}

stops = {
  30 => { North: ['Old Belchertown Rd', 'Colonial Village', 'Amherst Post Office', 'Studio Arts Building'],
          South: ['Puffton Village', 'GRC', 'Cowles Ln', 'Colonial Village', 'Old Belchertown Rd'] },
  31 => { North: ['The Boulders', 'Amherst Post Office', 'Studio Arts Building', 'Cliffside Apts'],
          South: ['Sugarloaf Estates', 'Townhouse Apts', 'GRC', 'Cowles Ln', 'The Boulders'] },
  38 => { North: ['Blanchard Hall', 'Hampshire College', 'Amherst College', 'Haigis Mall'],
          South: ['Haigis Mall', 'Amherst College', 'Hampshire College', 'Blanchard Hall'] }
}

# rubocop:disable Layout/HashAlignment
hastus_ids = {
  'Amherst College'      => 116,
  'Amherst Post Office'  => 96,
  'Blanchard Hall'       => 336,
  'Colonial Village'     => 120,
  'Cowles Ln'            => 95,
  'GRC'                  => 58,
  'Haigis Mall'          => 73,
  'Hampshire College'    => 236,
  'Old Belchertown Rd'   => 148,
  'Puffton Village'      => 34,
  'Studio Arts Building' => 72,
  'Sugarloaf Estates'    => 9,
  'The Boulders'         => 157,
  'Townhouse Apts'       => 30,
  'Cliffside Apts'       => 11
}
# rubocop:enable Layout/HashAlignment

stops.each do |route_number, stops_and_directions|
  stops_and_directions.each do |direction, stop_names|
    stop_names.each.with_index(1) do |stop_name, sequence|
      # Anytime in the last two months
      Timecop.freeze rand(86_400).minutes.ago do
        stop = BusStop.find_or_initialize_by name: stop_name
        stop.hastus_id = hastus_ids.fetch(stop_name)
        stop.save!
        route = routes.fetch(route_number)
        BusStopsRoute.create route: route,
                             sequence: sequence,
                             bus_stop: stop,
                             direction: direction
      end
    end
  end
end
