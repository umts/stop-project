# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'viewing outdated' do
  let!(:present_stop) { create :bus_stop }
  let!(:old_stop) { create :bus_stop, updated_at: 2.months.ago }

  before do
    create :bus_stop, updated_at: 3.months.ago
    when_current_user_is :admin
    visit outdated_bus_stops_path
  end

  it 'displays the correct number of stops' do
    expect(page).to have_css 'tbody tr', count: 2
  end

  it 'displays outdated stops' do
    expect(page).to have_css 'tbody tr', text: old_stop.updated_at.to_fs(:db_hm)
  end

  it 'does not display non-outdated stops' do
    expect(page).to have_no_css 'tbody tr', text: present_stop.updated_at.to_fs(:db_hm)
  end

  it 'allows editing of outdated stops' do
    within 'tr', text: old_stop.updated_at.to_fs(:db_hm) do
      click_link 'Edit'
    end
    expect(page).to have_content "Editing #{old_stop.name}"
  end

  context 'when specifying a different date' do
    let(:date_since) { Date.new(2012, 3, 4) }

    before do
      fill_in 'date', with: date_since
      click_button 'Change Date'
    end

    it 'displays outdated stops from that time' do
      expect(page).to have_content "Bus stops not updated since #{date_since}"
    end
  end
end
