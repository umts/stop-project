# frozen_string_literal: true

require 'spec_helper'

describe 'viewing outdated' do
  let!(:present_stop) { create :bus_stop }
  # default date for outdated is from a month ago
  let!(:date) { Date.today - 1.month }
  let!(:old_stop) { create :bus_stop, updated_at: (date - 2.months) }

  before do
    create :bus_stop, updated_at: (date - 3.months)
    when_current_user_is :admin
    visit outdated_bus_stops_path
  end

  it 'displays the correct number of stops' do
    expect(page).to have_selector 'table.manage tbody tr', count: 2
  end

  it 'displays outdated stops' do
    expect(page).to have_selector 'table.manage tbody tr',
                                  text: old_stop.updated_at.to_s(:db_hm)
  end

  it 'does not display non-outdated stops' do
    expect(page).not_to have_selector 'table.manage tbody tr',
                                      text: present_stop.updated_at.to_s(:db_hm)
  end

  it 'allows editing of outdated stops' do
    within 'tr', text: old_stop.updated_at.to_formatted_s(:db_hm) do
      click_link 'Edit'
    end
    expect(page).to have_content "Editing #{old_stop.name}"
  end

  context 'when using datepicker to specify different date', js: true do
    before do
      page.find_field('date').click # datepicker pops up
      within('table.ui-datepicker-calendar') { click_on '28' }
      click_on 'Change date'
    end

    it 'displays outdated stops from that time' do
      expect(page).to have_content "Bus stops not updated since #{date.change day: 28}"
    end
  end
end
