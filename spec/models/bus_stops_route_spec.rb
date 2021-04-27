# frozen_string_literal: true

require 'spec_helper'

describe BusStopsRoute do
  describe 'validations' do
    context 'same route and direction' do
      let(:route) { create :route }
      let(:stop1) { create :bus_stop }
      let :valid_bsr do
        create :bus_stops_route, route: route, bus_stop: stop1
      end

      context 'same sequence' do
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

  describe 'establish_sequences' do
    let(:main_variant) { %w[A B C D E] }
    let(:resequence!) { described_class.establish_sequences(@stop_hash) }
    let(:other_variant) { %w[A] }

    before do
      @stop_hash = { route_dir: { key1: main_variant, key2: other_variant } }
    end

    context 'all stops in other variant are in longest variant' do
      it 'preserves sequence of longest variant' do
        resequence!
        expect(@stop_hash[:route_dir]).to eql %w[A B C D E]
      end
    end

    context 'stop (but not first stop) in other variant is not in longest variant' do
      context 'one stop is in other variant' do
        let(:other_variant) { %w[A F E] }

        it 'inserts that stop into longest variant after common stop' do
          resequence!
          expect(@stop_hash[:route_dir]).to eql %w[A F B C D E]
        end
      end

      context 'multiple stops are in other variant' do
        let(:other_variant) { %w[A F G H E] }

        it 'inserts those stops into longest variant after common stop' do
          resequence!
          expect(@stop_hash[:route_dir]).to eql %w[A F G H B C D E]
        end
      end
    end

    context 'first stop in other variant is not in longest variant' do
      context 'one stop is in other variant' do
        let(:other_variant) { %w[F D E] }

        it 'inserts that stop into longest variant before common stop' do
          resequence!
          expect(@stop_hash[:route_dir]).to eql %w[A B C F D E]
        end
      end

      context 'multiple stops are in other variant' do
        let(:other_variant) { %w[F G H D E] }

        it 'inserts those stops into longest variant before common stop' do
          resequence!
          expect(@stop_hash[:route_dir]).to eql %w[A B C F G H D E]
        end
      end
    end

    context 'no stop in other variant is in the longest variant' do
      let(:other_variant) { %w[F G H I] }

      it 'appends other variant to end of longest variant' do
        resequence!
        expect(@stop_hash[:route_dir]).to eql %w[A B C D E F G H I]
      end
    end
  end
end
