# frozen_string_literal: true

require 'spec_helper'

describe 'searching for a bus stop by stop id' do
  let(:user) { create :user }
  let!(:bus_stop) { create :bus_stop }
  let(:incorrect_stop_id) { '-1' }
  before :each do
    when_current_user_is user
    visit root_url
  end
  context 'correct stop id' do
    it 'redirects to the edit page' do
      within 'form', text: 'Enter stop ID' do
        fill_in 'Enter stop ID', with: bus_stop.hastus_id.to_s
        click_button 'Search'
      end
      expect(page).to have_content "Editing #{bus_stop.name}"
    end
  end
  context 'incorrect stop id' do
    before :each do
      within 'form', text: 'Enter stop ID' do
        fill_in 'Enter stop ID', with: incorrect_stop_id
        click_button 'Search'
      end
    end
    it 'stays on the same page' do
      expect(page.current_url).to end_with root_path
    end
    it 'displays a helpful message' do
      expect(page).to have_selector 'p.notice',
                                    text: "Stop #{incorrect_stop_id} not found"
    end
  end
end

describe 'searching for a bus stop by stop name' do
  let(:user) { create :user }
  let!(:bus_stop) { create :bus_stop }
  let(:incorrect_stop_name) { 'stahp' }
  before :each do
    when_current_user_is user
    visit root_url
  end
  context 'correct stop name' do
    it 'redirects to the edit page' do
      within 'form', text: 'Enter stop name' do
        fill_in 'Enter stop name', with: bus_stop.name
        click_button 'Search'
      end
      expect(page).to have_content "Editing #{bus_stop.name}"
    end
  end
  context 'incorrect stop name' do
    before :each do
      within 'form', text: 'Enter stop name' do
        fill_in 'Enter stop name', with: incorrect_stop_name
        click_button 'Search'
      end
    end
    it 'stays on the same page' do
      expect(page.current_url).to end_with bus_stops_path
    end
    it 'displays a helpful message' do
      expect(page).to have_selector 'p.notice',
                                    text: "Stop #{incorrect_stop_name} not found"
    end
  end
  context 'without completing stop name' do
    it 'autofills' do
      # use the first character of the stop name so it's incomplete,
      # in order to be completed by autocomplete
      fill_in 'Enter stop name', with: bus_stop.name.chars.first
      find('div', text: bus_stop.name).click
      within 'form', text: 'Enter stop name' do
        click_button 'Search'
      end
      expect(page).to have_content "Editing #{bus_stop.name}"
    end
  end
end

describe 'searching for a bus stop by route' do
  let(:user) { create :user }
  let!(:route) { create :route }
  let!(:bus_stop) { create :bus_stop }
  let!(:bus_stops_route) do
    create :bus_stops_route,
           bus_stop: bus_stop,
           route: route
  end
  before :each do
    when_current_user_is user
    visit root_url
  end
  context 'route from the dropdown' do
    before :each do
      within 'form', text: 'Select a route' do
        select route.number, from: 'Select a route'
        click_button 'View stops'
      end
    end
    it 'redirects to bus stops by status' do
      expect(page).to have_content route.number
      expect(page.current_path).to end_with by_status_bus_stops_path
    end
    context 'click view by route order' do
      before :each do
        click_link 'View by route order'
      end
      it 'redirects to bus stops by sequence' do
        expect(page).to have_content route.number
        expect(page.current_path).to end_with by_sequence_bus_stops_path
      end
    end
  end
end
