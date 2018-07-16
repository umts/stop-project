require 'spec_helper'

describe BusStopsController, type: :controller do
  context 'incorrect route in params' do
    context 'viewing stops by status' do
      before :each do
        visit by_status_bus_stops_url(number: incorrect_route_number)
      end
      it 'redirects to index page' do
        expect(page.current_path).to end_with bus_stops_path
      end
      it 'displays a helpful message' do
        expect(page).to have_selector 'p.notice',
                                      text: 'Route -1 not found'
      end
    end
    context 'viewing stops by sequence' do
      before :each do
        visit by_sequence_bus_stops_url(number: incorrect_route_number)
      end
      it 'redirects to index page' do
        expect(page.current_path).to end_with bus_stops_path
      end
      it 'displays a helpful message' do
        expect(page).to have_selector 'p.notice',
                                      text: 'Route -1 not found'
      end
    end
  end
end
