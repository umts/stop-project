# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BusStop::Import do
  describe '#import!' do
    subject(:call) { described_class.new(source).import! }

    include_context 'a dummy source'

    before { create :bus_stop, name: 'Old Name', hastus_id: '1' }

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
