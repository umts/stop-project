# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BusStopsController do
  let(:incorrect_route_number) { '-1' }
  let!(:user) { create :user }

  before do
    when_current_user_is user
  end

  describe 'by_status' do
    let :submit do
      get :by_status, params: { number: incorrect_route_number }
    end

    context 'with an incorrect route in params' do
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

    context 'with an incorrect route in params' do
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
    subject(:submit) do
      put :update, params: { id: current_bus_stops_route.bus_stop.hastus_id,
                             bus_stop: current_bus_stops_route.bus_stop.attributes,
                             commit: 'Save and next',
                             route_id: route.id,
                             direction: current_bus_stops_route.direction }
    end

    let(:route) { create :route }
    let!(:current_bus_stops_route) { create :bus_stops_route, route: }
    let!(:next_bus_stops_route) { create :bus_stops_route, route: }

    it 'redirects to edit next stop when specifying a route and direction' do
      path = edit_bus_stop_path id: next_bus_stops_route.bus_stop.hastus_id,
                                direction: next_bus_stops_route.direction,
                                route_id: route.id
      submit
      expect(response).to redirect_to(path)
    end
  end
end
