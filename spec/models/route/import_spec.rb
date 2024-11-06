# frozen_string_literal: true

require 'gtfs'
require 'spec_helper'

RSpec.describe Route::Import do
  describe '#import!' do
    subject(:call) { described_class.new(source).import! }

    let(:route_data) { GTFS::Route.parse_routes file_fixture('routes.txt').read }
    let(:source) { instance_double GTFS::Source }

    before do
      create :route, number: 'ER', description: 'Old description'

      allow(source).to receive(:each_route) do |&block|
        route_data.each(&block)
      end
    end

    it 'imports routes' do
      expect { call }.to change(Route, :count).by(1)
    end

    it 'updates existing routes' do
      call
      expect(Route.find_by(number: 'ER').description).to eq 'Existing Route'
    end
  end
end
