# frozen_string_literal: true

require 'gtfs'

RSpec.shared_context 'with a dummy source' do
  let(:source) { instance_double GTFS::Source }

  let(:stop_data) { GTFS::Stop.parse_stops file_fixture('stops.txt').read }
  let(:route_data) { GTFS::Route.parse_routes file_fixture('routes.txt').read }
  let(:trip_data) { GTFS::Trip.parse_trips file_fixture('trips.txt').read }
  let(:stop_times_data) { GTFS::StopTime.parse_stop_times file_fixture('stop_times.txt').read }

  before do
    allow(source).to receive(:each_route) { |&block| route_data.each(&block) }
    allow(source).to receive(:each_stop) { |&block| stop_data.each(&block) }
    allow(source).to receive_messages(trips: trip_data, routes: route_data, stop_times: stop_times_data)
  end
end
