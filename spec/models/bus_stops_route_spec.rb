require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'same route and direction' do
      let!(:route) { create :route }
      let!(:direction) { 'West' }
      context 'same sequence' do
        it 'is not valid' do
          stop_1 = create :bus_stop
          stop_2 = create :bus_stop
          sequence = 1

          valid_bsr = create :bus_stops_route, route: route, bus_stop: stop_1, sequence: sequence, direction: direction
          invalid_bsr = build :bus_stops_route, route: route, bus_stop: stop_2, sequence: sequence, direction: direction
          
          expect(invalid_bsr).not_to be_valid
        end
      end
      context 'same bus_stop' do
        it 'is not valid' do
        end
      end
    end
  end
end
