require 'spec_helper'

describe BusStopsController do
  let(:incorrect_route_number) { '-1' }
  let!(:user) { create :user }
  before :each do
    when_current_user_is user
  end
  describe 'by_status' do
    let :submit do
      get :by_status, params: { number: incorrect_route_number }
    end
    context 'incorrect route in params' do
      it 'redirects to index page' do
        submit
        expect(response).to redirect_to bus_stops_path
      end
      it 'displays a helpful message' do
        submit
        expect(flash[:notice]).to eq "Route #{incorrect_route_number} not found"
      end
    end
  end
  describe 'by_sequence' do
    let :submit do
      get :by_sequence, params: { number: incorrect_route_number }
    end
    context 'incorrect route in params' do
      it 'redirects to index page' do
        submit
        expect(response).to redirect_to bus_stops_path
      end
      it 'displays a helpful message' do
        submit
        expect(flash[:notice]).to eq "Route #{incorrect_route_number} not found"
      end
    end
  end
  describe 'update' do
    let!(:route) { create :route }
    let!(:bus_stop_1) { create :bus_stop }
    let!(:bus_stop_2) { create :bus_stop }
    let!(:bus_stops_route_1) { create :bus_stops_route,
                                    route: route,
                                    bus_stop: bus_stop_1 }
    let!(:bus_stops_route_2) { create :bus_stops_route,
                                    route: route,
                                    bus_stop: bus_stop_2 }
    context 'update on sequence of routes' do
      before :each do
        put :update, params: { id: bus_stop_1.hastus_id,
                               bus_stop: { name: bus_stop_1.name },
                               commit: 'Save and next',
                               route_id: route.id,
                               direction: bus_stops_route_1.direction }
      end
      it 'redirects to edit next stop' do
        expect(response).to redirect_to edit_bus_stop_path(id: bus_stop_2.hastus_id, direction: bus_stops_route_2.direction, route_id: route.id)
      end
    end
  end
end
