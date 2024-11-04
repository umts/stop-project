# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'searching for a bus stop by stop id' do
  let(:user) { create :user }
  let!(:bus_stop) { create :bus_stop }
  let(:incorrect_stop_id) { '-1' }

  before do
    when_current_user_is user
    visit root_path
  end

  context 'with a correct stop id' do
    it 'redirects to the edit page' do
      within 'form', text: 'Enter Stop ID' do
        fill_in 'Enter Stop ID', with: bus_stop.hastus_id.to_s
        click_on 'Search'
      end
      expect(page).to have_content "Editing #{bus_stop.name}"
    end
  end

  context 'with an incorrect stop id' do
    before do
      within 'form', text: 'Enter Stop ID' do
        fill_in 'Enter Stop ID', with: incorrect_stop_id
        click_on 'Search'
      end
    end

    it 'stays on the same page' do
      expect(page).to have_current_path root_path
    end

    it 'displays a helpful message' do
      expect(page).to have_css '.alert', text: 'Stop not found'
    end
  end
end
