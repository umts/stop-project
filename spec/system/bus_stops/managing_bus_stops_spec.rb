# frozen_string_literal: true

require 'spec_helper'

describe 'managing stops as an admin' do
  let(:admin) { create :user, :admin }
  let!(:bus_stop) { create :bus_stop }

  before do
    when_current_user_is admin
    visit manage_bus_stops_path
  end

  describe 'the delete button' do
    it 'deletes the specific bus stop', js: true do
      expect(page).to have_selector 'table.manage tbody tr', count: 1
      within 'tr', text: bus_stop.hastus_id do
        click_button 'Delete'
      end
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector 'p.notice',
                                    text: "#{bus_stop.name} has been deleted."
      expect(page).not_to have_selector 'table.manage tbody tr',
                                        text: bus_stop.hastus_id
    end
  end

  describe 'the edit button' do
    it 'redirects to edit bus stop page' do
      expect(page).to have_selector 'table.manage tbody tr', count: 1
      within 'tr', text: bus_stop.hastus_id do
        click_link 'Edit'
      end
      expect(page).to have_content "Editing #{bus_stop.name}"
      expect(page).to have_current_path edit_bus_stop_path(bus_stop.hastus_id)
    end
  end
end
