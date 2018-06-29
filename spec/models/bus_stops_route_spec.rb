# frozen_string_literal: true

require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'same route and direction' do
      let(:route) { create :route }
      let(:stop_1) { create :bus_stop }
      let(:valid_bsr) do
        create :bus_stops_route,
               route: route,
               bus_stop: stop_1
      end
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
    let(:main_variant) { %w[A B C D E] }
    let(:route_dir) { %w[31 North] }
    context 'all stops are in longest variant' do
      it 'sequences stops correctly' do
        stop_hash = { route_dir => { 'm_North' => main_variant } }
        BusStopsRoute.import(stop_hash)
        expect(stop_hash[route_dir]).to be main_variant
      end
    end
    context 'stop (but not first stop) is not in longest variant' do
      context 'one stop is in other variant' do
        it 'sequences stops correctly' do
          sequenced_stops = %w[A F B C D E]
          stop_hash = { route_dir =>
                        { 'm_North' => main_variant,
                          'o_North' => %w[A F E] } }
          BusStopsRoute.import(stop_hash)
          expect(stop_hash[route_dir]).to eql sequenced_stops
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
