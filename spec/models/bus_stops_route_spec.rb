# frozen_string_literal: true

require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'same route and direction' do
      let(:route) { create :route }
      let(:stop_1) { create :bus_stop }
      let(:valid_bsr) {
        create :bus_stops_route,
               route: route,
               bus_stop: stop_1
      }
      context 'same sequence' do
        it 'is not valid' do
          stop_2 = create :bus_stop

          invalid_bsr = build :bus_stops_route,
                              route: valid_bsr.route,
                              direction: valid_bsr.direction,
                              sequence: valid_bsr.sequence,
                              bus_stop: stop_2
          expect(invalid_bsr).not_to be_valid
        end
      end
      context 'same bus_stop' do
        it 'is not valid' do
          invalid_bsr = build :bus_stops_route,
                              route: valid_bsr.route,
                              direction: valid_bsr.direction,
                              bus_stop: valid_bsr.bus_stop
          expect(invalid_bsr).not_to be_valid
        end
      end
    end
  end
  describe 'import' do
    context 'all stops are in longest variant' do
      it 'sequences stops correctly' do
      end
    end
    context 'stop (but not first stop) is not in longest variant' do
      context 'one stop is in other variant' do
        it 'sequences stops correctly' do
        end
      end
      context 'multiple stops are in other variant' do
        it 'sequences stops correctly' do
        end
      end
    end
    context 'first stop is not in longest variant' do
      context 'one stop is in other variant' do
        it 'sequences stops correctly' do
        end
      end
      context 'multiple stops are in other variant' do
        it 'sequences stops correctly' do
        end
      end
    end
    context 'no stop is in the longest variant' do
      it 'sequences stops correctly' do
      end
    end
  end
end
