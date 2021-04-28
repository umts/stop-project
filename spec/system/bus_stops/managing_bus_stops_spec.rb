# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'managing stops as an admin' do
  let(:admin) { create :user, :admin }
  let!(:bus_stop) { create :bus_stop }
  before :each do
    when_current_user_is admin
    visit manage_bus_stops_path
  end
  context 'delete button' do
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
  context 'edit button' do
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

RSpec.describe 'viewing outdated' do
  let(:admin) { create :user, :admin }
  let!(:present_stop) { create :bus_stop }
  # default date for outdated is from a month ago
  let!(:date) { Date.today - 1.month }
  let(:picked_date) { date.change(day: 28) }
  let!(:old_stop_1) { create :bus_stop, updated_at: (date - 2.months) }
  let!(:old_stop_2) { create :bus_stop, updated_at: (date - 3.months) }
  before :each do
    when_current_user_is admin
    visit manage_bus_stops_path
    click_link 'View Outdated'
  end
  it 'redirects to outdated page' do
    expect(page).to have_current_path outdated_bus_stops_path
  end
  it 'displays only outdated stops' do
    expect(page).to have_selector 'table.manage tbody tr',
                                  count: 2
    expect(page).to have_selector 'table.manage tbody tr',
                                  text: old_stop_1.updated_at.to_formatted_s(:db_hm)
    expect(page).to have_selector 'table.manage tbody tr',
                                  text: old_stop_2.updated_at.to_formatted_s(:db_hm)
    expect(page).not_to have_selector 'table.manage tbody tr',
                                  text: present_stop.updated_at.to_formatted_s(:db_hm)
  end
  it 'allows editing of outdated stops' do
    within 'tr', text: old_stop_1.updated_at.to_formatted_s(:db_hm) do
      click_link 'Edit'
    end
    expect(page).to have_content "Editing #{old_stop_1.name}"
  end
  context 'using datepicker to specify different date', js: true do
    it 'displays outdated stops from that time' do
      within 'form' do
        page.find_by_id('date').click
        # datapicker pops up
      end
      within 'table.ui-datepicker-calendar tbody tr td', text: '28' do
        page.find('.ui-state-default').click
      end
      within 'form' do
        click_on 'Change date'
      end
      expect(page).to have_content "Bus stops not updated since #{picked_date}"
    end
  end
end
