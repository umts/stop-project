# frozen_string_literal: true

require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'same route and direction' do
      let!(:route) { create :route }
      let!(:stop_1) { create :bus_stop }
      let!(:valid_bsr) { create :bus_stops_route, route: route, bus_stop: stop_1 }
      context 'same sequence' do
        it 'is not valid' do
          stop_2 = create :bus_stop

          invalid_bsr = build :bus_stops_route, route: valid_bsr.route,
                                                bus_stop: stop_2,
                                                sequence: valid_bsr.sequence,
                                                direction: valid_bsr.direction

          expect(invalid_bsr).not_to be_valid
        end
      end
      context 'same bus_stop' do
        it 'is not valid' do
          invalid_bsr = build :bus_stops_route, route: valid_bsr.route,
                                                bus_stop: valid_bsr.bus_stop,
                                                direction: valid_bsr.direction

          expect(invalid_bsr).not_to be_valid
        end
      end
    end
  end
end
