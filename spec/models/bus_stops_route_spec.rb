# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BusStopsRoute do
  describe 'validations' do
    context 'when two bus stops have the same route and direction' do
      let(:route) { create :route }
      let(:stop1) { create :bus_stop }
      let :valid_bsr do
        create :bus_stops_route, route:, bus_stop: stop1
      end

      context 'when they have the same sequence' do
        let :invalid_bsr do
          build :bus_stops_route, route: valid_bsr.route,
                                  direction: valid_bsr.direction,
                                  sequence: valid_bsr.sequence
        end

        it 'is not valid' do
          expect(invalid_bsr).not_to be_valid
        end
      end

      context 'when they have the same bus stop' do
        let :invalid_bsr do
          build :bus_stops_route, route: valid_bsr.route,
                                  direction: valid_bsr.direction,
                                  bus_stop: valid_bsr.bus_stop
        end

        it 'is not valid' do
          expect(invalid_bsr).not_to be_valid
        end
      end
    end
  end
end
