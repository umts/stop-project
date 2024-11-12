# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BusStopsRoute::Import do
  describe '#combined_trip_data' do
    subject(:call) { importer.combined_trip_data }

    let(:importer) { described_class.new 'DUMMYSOURCE' }
    let(:combined_data) { ->(seq) { { %w[RT D] => seq } } }

    before do
      allow(importer).to receive(:trip_data).and_return({ %w[RT D] => stop_sequences })
    end

    context 'when all stops in other variant are in longest variant' do
      let(:stop_sequences) { [%w[A B C D E], %w[B C]] }

      it 'preserves sequence of longest variant' do
        expect(call).to eq combined_data[%w[A B C D E]]
      end
    end

    context 'when a stop (but not the 1st stop) in another variant is not in the longest variant' do
      context 'when one stop is in the other variant' do
        let(:stop_sequences) { [%w[A B C D E], %w[C F]] }

        it 'inserts that stop into longest variant after common stop' do
          expect(call).to eq combined_data[%w[A B C F D E]]
        end
      end

      context 'when multiple stops are in the other variant' do
        let(:stop_sequences) { [%w[A B C D E], %w[C F G H]] }

        it 'inserts those stops into longest variant after common stop' do
          expect(call).to eq combined_data[%w[A B C F G H D E]]
        end
      end
    end

    context 'when the first stop in another variant is not in the longest variant' do
      context 'when one stop is in the other variant' do
        let(:stop_sequences) { [%w[A B C D E], %w[F D E]] }

        it 'inserts that stop into longest variant before common stop' do
          expect(call).to eq combined_data[%w[A B C F D E]]
        end
      end

      context 'when multiple stops are in the other variant' do
        let(:stop_sequences) { [%w[A B C D E], %w[F G H D E]] }

        it 'inserts those stops into longest variant before common stop' do
          expect(call).to eq combined_data[%w[A B C F G H D E]]
        end
      end
    end

    context 'when no stop in the other variant is in the longest variant' do
      let(:stop_sequences) { [%w[A B C D E], %w[F G H I]] }

      it 'appends the other variant to the end of the longest variant' do
        expect(call).to eql combined_data[%w[A B C D E F G H I]]
      end
    end
  end

  describe '#import!' do
    subject(:call) { described_class.new(source).import! }

    include_context 'a dummy source'

    let!(:route) { create :route, number: 'ER' }

    before { BusStop::Import.new(source).import! }

    it 'destroys existing bus stops routes for the route and direction' do
      bus_stop = create(:bus_stops_route, route: route, direction: '0').bus_stop
      call
      expect(BusStopsRoute.find_by(bus_stop:, route:)).to be_nil
    end

    it 'does not destroy bus stops routes for other routes' do
      route = create :route, number: '55'
      bus_stop = create(:bus_stops_route, route: route, direction: '0').bus_stop
      call
      expect(BusStopsRoute.find_by(bus_stop:, route:)).to be_present
    end

    it 'does not destroy bus stops routes for other directions' do
      bus_stop = create(:bus_stops_route, route: route, direction: 'SKYWARD').bus_stop
      call
      expect(BusStopsRoute.find_by(bus_stop:, route:)).to be_present
    end

    it 'creates bus stops routes for the route' do
      call
      expect(route.bus_stops_routes.count).to eq(stop_times_data.count - 1) # One common stop between two trips
    end

    it 'creates bus stops routes with the correct directions' do
      call
      expect(route.bus_stops_routes.pluck(:direction).uniq).to eq %w[0 1]
    end

    it 'creates bus stops routes with the correct combined stop sequence' do
      call
      bus_stops_routes = route.bus_stops_routes.order(:sequence).where(direction: '0')
      expect(bus_stops_routes.map { |bsr| bsr.bus_stop.hastus_id }).to eq %w[A B C D E D1 E1 F]
    end

    it 'creates bus stops routes with the correct sequence numbers' do
      call
      bus_stops_routes = route.bus_stops_routes.order(:sequence).where(direction: '1')
      expect(bus_stops_routes.pluck(:sequence)).to eq (1..6).to_a
    end
  end
end
