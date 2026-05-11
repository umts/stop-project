# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'viewing stops by sequence' do
  subject(:by_sequence_view) { page }

  let(:route) { create :route }
  let!(:bsr) do
    create :bus_stops_route, route:
  end
  let!(:pending_bsr) do
    stop = create :bus_stop, :pending
    create :bus_stops_route, route:, bus_stop: stop
  end
  let!(:completed_bsr) do
    stop = create :bus_stop, :completed
    create :bus_stops_route, route:, bus_stop: stop
  end

  before do
    when_current_user_is :anyone
    visit by_sequence_bus_stops_path(number: route.number)
  end

  it { is_expected.to have_text(bsr.direction) }
  it { is_expected.to have_text(bsr.sequence) }
  it { is_expected.to have_text(pending_bsr.sequence) }
  it { is_expected.to have_text(completed_bsr.sequence) }
end
