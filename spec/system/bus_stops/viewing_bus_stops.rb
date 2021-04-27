# frozen_string_literal: true

require 'spec_helper'

describe 'viewing stops by status' do
  let(:user) { create :user }
  let!(:route) { create :route }
  let!(:pending_stop) { create :bus_stop, :pending }
  let!(:not_started_stop) { create :bus_stop }
  let!(:completed_stop) { create :bus_stop, :completed }
  let!(:bsr1) { create :bus_stops_route, route: route, bus_stop: pending_stop }
  let!(:bsr2) { create :bus_stops_route, route: route, bus_stop: not_started_stop }
  let!(:bsr3) { create :bus_stops_route, route: route, bus_stop: completed_stop }

  before do
    when_current_user_is user
    visit by_status_bus_stops_path(number: route.number)
  end

  context 'with pending, not started, and completed stops' do
    it 'displays according to status' do
      expect(page).to have_content 'Pending Stops'
      within 'div div', text: 'Pending Stops' do
        expect(page).to have_selector('ul li a', text: pending_stop.name)
      end
      expect(page).to have_content 'Not Started Stops'
      within 'div div', text: 'Not Started Stops' do
        expect(page).to have_selector('ul li a', text: not_started_stop.name)
      end
      expect(page).to have_content 'Completed Stops'
      within 'div div', text: 'Completed Stops' do
        expect(page).to have_selector('ul li a', text: completed_stop.name)
      end
    end
  end
end

describe 'viewing stops by sequence' do
  let(:user) { create :user }
  let(:route) { create :route }
  let(:stop1) { create :bus_stop, :pending }
  let(:stop2) { create :bus_stop }
  let(:stop3) { create :bus_stop, :completed }
  let!(:bsr1) { create :bus_stops_route, route: route, bus_stop: stop1 }
  let!(:bsr2) { create :bus_stops_route, route: route, bus_stop: stop2 }
  let!(:bsr3) { create :bus_stops_route, route: route, bus_stop: stop3 }

  before do
    when_current_user_is user
    visit by_sequence_bus_stops_path(number: route.number)
  end

  context 'with stops' do
    it 'displays according to sequence' do
      expect(page).to have_content bsr1.direction
      expect(page).to have_content bsr1.sequence
      expect(page).to have_content bsr2.sequence
      expect(page).to have_content bsr3.sequence
    end
  end
end
