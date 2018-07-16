require 'spec_helper'

describe BusStopsController, type: :controller do
  let(:incorrect_route_number) { '-1' }
  describe 'by_status' do
    let :submit do
      get :by_status, params: { number: incorrect_route_number }
    end
    context 'incorrect route in params' do
      it 'redirects to index page' do
        submit
        expect(response).to redirect_to :index
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
      end
      it 'displays a helpful message' do
      end
    end
  end
end
