# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'searching for a bus stop by stop name' do
  let(:user) { create :user }
  let!(:bus_stop) { create :bus_stop }
  let(:incorrect_stop_name) { 'stahp' }

  before do
    when_current_user_is user
    visit root_path
  end

  context 'with a correct stop name' do
    it 'redirects to the edit page' do
      within 'form', text: 'Enter Stop Name' do
        fill_in 'Enter Stop Name', with: bus_stop.name
        click_button 'Search'
      end
      expect(page).to have_content "Editing #{bus_stop.name}"
    end
  end

  context 'with an incorrect stop name' do
    before do
      within 'form', text: 'Enter Stop Name' do
        fill_in 'Enter Stop Name', with: incorrect_stop_name
        click_button 'Search'
      end
    end

    it 'stays on the same page' do
      expect(page).to have_current_path root_path
    end

    it 'displays a helpful message' do
      expect(page).to have_selector 'p.notice', text: "Stop #{incorrect_stop_name} not found"
    end
  end

  context 'without completing stop name' do
    it 'autocompletes', js: true do
      find '[data-autocomplete-ready-value=true]'
      fill_in 'Enter Stop Name', with: bus_stop.name.first
      click_on bus_stop.name
      expect(page).to have_content "Editing #{bus_stop.name}"
    end
  end
end
