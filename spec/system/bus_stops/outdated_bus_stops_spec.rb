# frozen_string_literal: true

require 'spec_helper'

describe 'viewing outdated' do
  let(:admin) { create :user, :admin }
  let!(:present_stop) { create :bus_stop }
  # default date for outdated is from a month ago
  let!(:date) { Date.today - 1.month }
  let(:picked_date) { date.change(day: 28) }
  let!(:old_stop1) { create :bus_stop, updated_at: (date - 2.months) }
  let!(:old_stop2) { create :bus_stop, updated_at: (date - 3.months) }

  before do
    when_current_user_is admin
    visit outdated_bus_stops_path
  end

  it 'displays only outdated stops' do
    expect(page).to have_selector 'table.manage tbody tr',
                                  count: 2
    expect(page).to have_selector 'table.manage tbody tr',
                                  text: old_stop1.updated_at.to_formatted_s(:db_hm)
    expect(page).to have_selector 'table.manage tbody tr',
                                  text: old_stop2.updated_at.to_formatted_s(:db_hm)
    expect(page).not_to have_selector 'table.manage tbody tr',
                                      text: present_stop.updated_at.to_formatted_s(:db_hm)
  end

  it 'allows editing of outdated stops' do
    within 'tr', text: old_stop1.updated_at.to_formatted_s(:db_hm) do
      click_link 'Edit'
    end
    expect(page).to have_content "Editing #{old_stop1.name}"
  end

  context 'when using datepicker to specify different date', js: true do
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
