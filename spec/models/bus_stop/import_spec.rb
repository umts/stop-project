# frozen_string_literal: true

require 'gtfs'
require 'spec_helper'

RSpec.describe BusStop::Import do
  describe '#import!' do
    subject(:call) { described_class.new(source).import! }

    let(:stop_data) { GTFS::Stop.parse_stops file_fixture('stops.txt').read }
    let(:source) { instance_double GTFS::Source }

    before do
      create :bus_stop, name: 'Old Name', hastus_id: '1'

      allow(source).to receive(:each_stop) do |&block|
        stop_data.each(&block)
      end
    end

    it 'imports stops' do
      expect { call }.to change(BusStop, :count).by(stop_data.count - 2) # (The two cases below)
    end

    it 'updates existing stops' do
      call
      expect(BusStop.find_by(hastus_id: '1').name).to eq 'Existing Stop'
    end

    it 'skips stations' do
      call
      expect(BusStop.find_by(name: 'Big Station')).to be_nil
    end
  end
end
