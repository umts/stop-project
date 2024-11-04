# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BusStop do
  let!(:pending_stop) { create :bus_stop, :pending }
  let!(:completed_stop) { create :bus_stop, :completed }
  let!(:not_started_stop) { create :bus_stop }

  describe 'decide_if_completed_by' do
    let(:user) { create :user }
    let(:stop) { create :bus_stop, :pending }

    context 'when the bus stop completed attribute changed to true' do
      it 'assigns user to completed by' do
        stop.update! accessible: true
        stop.completed = true
        stop.decide_if_completed_by user
        expect(stop.completed_by).to eql user
      end
    end

    context 'when the bus stop completed attribute changed to false' do
      it 'assigns nil to completed by' do
        completed_stop.completed = false
        completed_stop.decide_if_completed_by user
        expect(completed_stop.completed_by).to be_nil
      end
    end
  end

  describe 'completed scope' do
    subject(:scope) { described_class.completed }

    it { is_expected.to include completed_stop }
    it { is_expected.not_to include pending_stop }
    it { is_expected.not_to include not_started_stop }
  end

  describe 'not_started scope' do
    subject(:scope) { described_class.not_started }

    it { is_expected.to include not_started_stop }
    it { is_expected.not_to include completed_stop }
    it { is_expected.not_to include pending_stop }
  end

  describe 'pending scope' do
    subject(:scope) { described_class.pending }

    it { is_expected.to include pending_stop }
    it { is_expected.not_to include completed_stop }
    it { is_expected.not_to include not_started_stop }
  end

  describe 'validations' do
    it 'is not valid if bus stop is not completed but assigned completed' do
      invalid_stop = build :bus_stop, completed: true, accessible: nil
      expect(invalid_stop).not_to be_valid
    end
  end
end
