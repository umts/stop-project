require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'same route and direction' do
      context 'same bus stop' do
        it 'is not valid' do
          route = create :route
          stop_1 = create :bus_stop
          stop_2 = create :bus_stop
          direction = 'West'
          sequence = 1

          valid_bsr = create :bus_stops_route, route: route, bus_stop: stop_1, sequence: sequence, direction: direction
          invalid_bsr = build :bus_stops_route, route: route, bus_stop: stop_2, sequence: sequence, direction: direction
          
          expect(invalid_bsr).not_to be_valid
        end
      end
      context 'same sequence' do
        it 'is not valid' do
        end
      end
    end
  end
end
