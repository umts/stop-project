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
  before :each do
    when_current_user_is user
    visit by_status_bus_stops_path(number: route.number)
  end
  context 'with pending, not started, and completed stops' do
    it 'displays according to status' do
      expect(page).to have_content 'Pending Stops'
      expect(page).to have_content pending_stop.name
      expect(page).to have_content 'Not Started Stops'
      expect(page).to have_content not_started_stop.name
      expect(page).to have_content 'Completed Stops'
      expect(page).to have_content completed_stop.name
    end
  end
end

describe 'viewing stops by sequence' do
  let(:user) { create :user }
  let!(:route) { create :route }
  let!(:stop_1) { create :bus_stop, :pending }
  let!(:stop_2) { create :bus_stop }
  let!(:stop_3) { create :bus_stop, :completed }
  let!(:bsr1) { create :bus_stops_route, route: route, bus_stop: stop_1 }
  let!(:bsr2) { create :bus_stops_route, route: route, bus_stop: stop_2 }
  let!(:bsr3) { create :bus_stops_route, route: route, bus_stop: stop_3 }
  before :each do
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
