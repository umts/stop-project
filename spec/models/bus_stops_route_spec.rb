# frozen_string_literal: true

require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'when two bus stops have the same route and direction' do
      let(:route) { create :route }
      let(:stop1) { create :bus_stop }
      let :valid_bsr do
        create :bus_stops_route, route: route, bus_stop: stop1
      end

      context 'when they have the same sequence' do
        it 'is not valid' do
          stop2 = create :bus_stop

          invalid_bsr = build :bus_stops_route,
                              route: valid_bsr.route,
                              direction: valid_bsr.direction,
                              sequence: valid_bsr.sequence,
                              bus_stop: stop2
          expect(invalid_bsr).not_to be_valid
        end
      end

      context 'when they have the same bus stop' do
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

  describe 'establish_sequences' do
    let(:main_variant) { %w[A B C D E] }
    let(:other_variant) { %w[A] }
    let(:stop_hash) { { route_dir: { key1: main_variant, key2: other_variant } } }

    before { described_class.establish_sequences(stop_hash) }

    context 'when all stops in other variant are in longest variant' do
      it 'preserves sequence of longest variant' do
        expect(stop_hash[:route_dir]).to eql %w[A B C D E]
      end
    end

    context 'when a stop (but not the 1st stop) in another variant is not in the longest variant' do
      context 'when one stop is in the other variant' do
        let(:other_variant) { %w[A F E] }

        it 'inserts that stop into longest variant after common stop' do
          expect(stop_hash[:route_dir]).to eql %w[A F B C D E]
        end
      end

      context 'when multiple stops are in the other variant' do
        let(:other_variant) { %w[A F G H E] }

        it 'inserts those stops into longest variant after common stop' do
          expect(stop_hash[:route_dir]).to eql %w[A F G H B C D E]
        end
      end
    end

    context 'when the first stop in another variant is not in the longest variant' do
      context 'when one stop is in the other variant' do
        let(:other_variant) { %w[F D E] }

        it 'inserts that stop into longest variant before common stop' do
          expect(stop_hash[:route_dir]).to eql %w[A B C F D E]
        end
      end

      context 'when multiple stops are in the other variant' do
        let(:other_variant) { %w[F G H D E] }

        it 'inserts those stops into longest variant before common stop' do
          expect(stop_hash[:route_dir]).to eql %w[A B C F G H D E]
        end
      end
    end

    context 'when no stop in the other variant is in the longest variant' do
      let(:other_variant) { %w[F G H I] }

      it 'appends the other variant to the end of the longest variant' do
        expect(stop_hash[:route_dir]).to eql %w[A B C D E F G H I]
      end
    end
  end
end
