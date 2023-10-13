# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'searching for a bus stop by route' do
  let(:route) { create :route }

  before do
    create :bus_stops_route, route: route
    when_current_user_is :anyone
    visit root_path
  end

  context 'when selecting a route from the dropdown' do
    before do
      select route.number, from: 'Select a Route'
      click_button 'View Stops'
    end

    it 'redirects to bus stops by status' do
      expect(page).to have_current_path(by_status_bus_stops_path, ignore_query: true)
    end

    it 'shows the by-status page for the correct route' do
      expect(page).to have_text("Route #{route.number} Bus Stops")
    end

    context 'when viewing by route order' do
      before do
        click_link 'View by route order'
      end

      it 'redirects to bus stops by sequence' do
        path = by_sequence_bus_stops_path(number: route.number)
        expect(page).to have_current_path(path)
      end
    end
  end
end
