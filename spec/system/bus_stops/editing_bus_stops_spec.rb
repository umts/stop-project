# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'editing a bus stop as a user' do
  let!(:user) { create :user }
  let!(:edit_stop) { create :bus_stop }

  before do
    when_current_user_is user
    visit edit_bus_stop_path(edit_stop.hastus_id)
  end

  context 'with no changes' do
    before { click_on 'Save stop' }

    it 'displays a message that says stop was updated' do
      expect(page).to have_selector '.alert',
                                    text: 'Bus stop was updated'
    end

    it 'redirects to the bus stops page' do
      expect(page).to have_current_path bus_stops_path
    end
  end

  context 'with data changes' do
    before do
      select 'UMTS', from: 'Garage responsible'
      click_on 'Save stop'
    end

    it 'displays a message that says stop was updated' do
      expect(page).to have_selector '.alert',
                                    text: 'Bus stop was updated'
    end

    it 'redirects to the bus stops page' do
      expect(page).to have_current_path bus_stops_path
    end
  end

  context 'with errors' do
    before do
      check 'Completed'
      click_on 'Save stop'
    end

    it 'sends a helpful error message' do
      expect(page).to have_text "Bench can't be blank"
    end

    it 'stays on the edit page' do
      # url doesn't change to edit page
      expect(page).to have_current_path bus_stop_path(edit_stop.hastus_id)
    end
  end

  context 'when clicking on the field guide link' do
    before { click_on 'Field Guide' }

    it 'redirects to the field guide' do
      expect(page).to have_current_path field_guide_bus_stops_path
    end
  end

  context 'with a bus stop that has been previously edited' do
    let(:last_user) { create :user }
    let(:user) { create :user }
    let(:edit_stop) { create :bus_stop }

    before do
      Timecop.freeze Date.yesterday do
        when_current_user_is last_user
        visit edit_bus_stop_path(edit_stop.hastus_id)
        click_button 'Save stop'
      end

      when_current_user_is user
      visit edit_bus_stop_path(edit_stop.hastus_id)
    end

    it 'displays who updated it and when' do
      updated = Date.yesterday.to_fs(:long_with_time)
      expect(page).to have_content "Last updated by #{last_user.name} on #{updated}"
    end
  end

  context 'with a bus stop that has been completed' do
    let(:last_user) { create :user }
    let(:user) { create :user }
    let(:edit_stop) { create :bus_stop, :pending }

    before do
      Timecop.freeze Date.yesterday do
        when_current_user_is last_user
        visit edit_bus_stop_path(edit_stop.hastus_id)

        select 'UMTS', from: 'Garage responsible'
        check 'Completed'
        click_button 'Save stop'
      end

      when_current_user_is user
      visit edit_bus_stop_path(edit_stop.hastus_id)
    end

    it 'displays who updated it and when' do
      completed = Date.yesterday.to_fs(:long_with_time)
      expect(page).to have_content "Completed by #{last_user.name} on #{completed}"
    end
  end
end
