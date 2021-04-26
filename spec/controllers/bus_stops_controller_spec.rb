# frozen_string_literal: true

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
    let(:route) { create :route }
    let(:bus_stop1) { create :bus_stop }
    let(:bus_stop2) { create :bus_stop }
    let!(:bus_stops_route1) do
      create :bus_stops_route, route: route, bus_stop: bus_stop1
    end
    let!(:bus_stops_route2) do
      create :bus_stops_route, route: route, bus_stop: bus_stop2
    end

    context 'update on sequence of routes' do
      before :each do
        put :update, params: { id: bus_stop1.hastus_id,
                               bus_stop: { name: bus_stop1.name },
                               commit: 'Save and next',
                               route_id: route.id,
                               direction: bus_stops_route1.direction }
      end
      it 'redirects to edit next stop' do
        path = edit_bus_stop_path id: bus_stop2.hastus_id,
                                  direction: bus_stops_route2.direction,
                                  route_id: route.id
        expect(response).to redirect_to(path)
      end
    end
  end
end
