# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'managing stops as an admin' do
  let(:admin) { create :user, :admin }
  let!(:bus_stop) { create :bus_stop }

  before do
    when_current_user_is admin
    visit manage_bus_stops_path
  end

  describe 'the delete button', js: true do
    subject(:click_delete) do
      accept_alert do
        within 'tr', text: bus_stop.hastus_id do
          click_button 'Delete'
        end
      end
    end

    it 'deletes the specific bus stop' do
      click_delete
      expect(page).not_to have_selector 'table.manage tbody tr', text: bus_stop.hastus_id
    end

    it 'informs you of the deletion' do
      click_delete
      expect(page).to have_selector '.alert', text: "#{bus_stop.name} has been deleted."
    end
  end

  describe 'the edit button' do
    subject(:click_edit) do
      within 'tr', text: bus_stop.hastus_id do
        click_link 'Edit'
      end
    end

    it 'redirects to edit bus stop page' do
      click_edit
      expect(page).to have_current_path edit_bus_stop_path(bus_stop.hastus_id)
    end
  end
end
