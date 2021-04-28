# frozen_string_literal: true

require 'spec_helper'

describe 'searching for a bus stop by route' do
  let(:user) { create :user }
  let!(:route) { create :route }
  let!(:bus_stop) { create :bus_stop }
  let!(:bus_stops_route) do
    create :bus_stops_route,
           bus_stop: bus_stop,
           route: route
  end

  before do
    when_current_user_is user
    visit root_path
  end

  context 'when selecting a route from the dropdown' do
    before do
      within 'form', text: 'Select a route' do
        select route.number, from: 'Select a route'
        click_button 'View stops'
      end
    end

    it 'redirects to bus stops by status' do
      expect(page).to have_content route.number
      expect(page.current_path).to end_with by_status_bus_stops_path
    end

    context 'when viewing by route order' do
      before do
        click_link 'View by route order'
      end

      it 'redirects to bus stops by sequence' do
        expect(page).to have_content route.number
        expect(page.current_path).to end_with by_sequence_bus_stops_path
      end
    end
  end
end
