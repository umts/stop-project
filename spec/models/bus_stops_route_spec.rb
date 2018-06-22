require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'same bus stop in same route and direction' do
      it 'is not valid' do
        direction = 'West'
        sequence = 1
        route = create :route
        bs1 = create :bus_stop
        bs2 = create :bus_stop

        # create bus_stops_route with same sequence number and direction
        bsr1 = create :bus_stops_route, route: route, bus_stop: bs1, sequence: sequence, direction: direction
        bsr2 = build :bus_stops_route, route: route, bus_stop: bs2, sequence: sequence, direction: direction
        
        expect(bsr2).not_to be_valid
      end
    end
    context 'same sequence in same route and direction' do
      it 'is not valid' do
      end
    end
  end
end
