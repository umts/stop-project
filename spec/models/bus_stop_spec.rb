require 'spec_helper'

describe BusStop do
  let!(:pending_stop) { create :bus_stop, :pending }
  let!(:completed_stop) { create :bus_stop, :completed }
  let!(:not_started_stop) { create :bus_stop }
  describe 'decide_if_completed_by' do
    let(:user) { create :user }
    let(:stop) { create :bus_stop, :pending }
    context 'bus stop completed attribute changed' do
      context 'bus stop is completed' do
        it 'assigns user to completed by' do
          stop.update! accessible: true
          stop.completed = true
          stop.decide_if_completed_by user
          expect(stop.completed_by).to eql user
        end
      end
      context 'bus stop is not completed' do
        it 'assigns nil to completed by' do
          stop.decide_if_completed_by user
          expect(stop.completed_by).to be nil
        end
      end
    end
  end

  describe 'completed scope' do
    it 'returns completed bus stops' do
      expect(BusStop.completed).to include completed_stop
      expect(BusStop.completed).not_to include pending_stop
      expect(BusStop.completed).not_to include not_started_stop
    end
  end

  describe 'not_started scope' do
    it 'returns bus stops without data entered' do
      expect(BusStop.not_started).to include not_started_stop
      expect(BusStop.not_started).not_to include completed_stop
      expect(BusStop.not_started).not_to include pending_stop
    end
  end

  describe 'pending scope' do
    it 'returns pending bus stops' do
      expect(BusStop.pending).to include pending_stop
      expect(BusStop.pending).not_to include completed_stop
      expect(BusStop.pending).not_to include not_started_stop
    end
  end

  describe 'validations' do
    context 'bus stop is not completed but assigned completed' do
      it 'is not valid' do
        invalid_stop = build :bus_stop, completed: true, accessible: nil
        expect(invalid_stop).not_to be_valid
      end
    end
  end
end