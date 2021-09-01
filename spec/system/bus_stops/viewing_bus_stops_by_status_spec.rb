# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'viewing stops by status' do
  let(:route) { create :route }
  let(:pending_stop) { create :bus_stop, :pending }
  let(:not_started_stop) { create :bus_stop }
  let(:completed_stop) { create :bus_stop, :completed }

  before do
    create :bus_stops_route, route: route, bus_stop: pending_stop
    create :bus_stops_route, route: route, bus_stop: not_started_stop
    create :bus_stops_route, route: route, bus_stop: completed_stop
    when_current_user_is :anyone
    visit by_status_bus_stops_path(number: route.number)
  end

  it 'has a section for pending stops' do
    expect(page).to have_content 'Pending Stops'
  end

  it 'displays pending stops' do
    within 'ul.pending' do
      expect(page).to have_link(text: pending_stop.name)
    end
  end

  it 'has a section for not-started stops' do
    expect(page).to have_content 'Not Started Stops'
  end

  it 'displays not-started stops' do
    within 'ul.not-started' do
      expect(page).to have_link(text: not_started_stop.name)
    end
  end

  it 'has a section for completed stops' do
    expect(page).to have_content 'Completed Stops'
  end

  it 'displays completed stops' do
    within 'ul.completed' do
      expect(page).to have_link(text: completed_stop.name)
    end
  end
end
