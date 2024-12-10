# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Route::Import do
  describe '#import!' do
    subject(:call) { described_class.new(source).import! }

    include_context 'with a dummy source'

    before { create :route, number: 'ER', description: 'Old description' }

    it 'imports routes' do
      expect { call }.to change(Route, :count).by(1)
    end

    it 'updates existing routes' do
      call
      expect(Route.find_by(number: 'ER').description).to eq 'Existing Route'
    end
  end
end
