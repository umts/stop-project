
require 'spec_helper'

describe 'editing a bus stop as a user' do
  let!(:user) { create :user }
  let!(:edit_stop) { create :bus_stop }
  before :each do
    when_current_user_is user
    visit edit_bus_stop_path(edit_stop.hastus_id)
  end
  context 'with no changes' do
    before :each do
      within 'table.edit-form' do
        click_button 'Save stop'
      end
    end
    it 'displays a message that says stop was updated' do
      expect(page).to have_selector 'p.notice',
                                    text: 'Bus stop was updated.'
    end
    it 'redirects to the bus stops page' do
      expect(page).to have_current_path bus_stops_path
    end
  end
  context 'with data changes' do
    before :each do
      within 'table.edit-form' do
        select 'UMTS', from: 'Garage responsible'
        click_button 'Save stop'
      end
    end
    it 'displays a message that says stop was updated' do
      expect(page).to have_selector 'p.notice',
                                    text: 'Bus stop was updated.'
    end
    it 'redirects to the bus stops page' do
      expect(page).to have_current_path bus_stops_path
    end
  end
  context 'with errors' do
    before :each do
      within 'table.edit-form' do
        check 'Completed'
        click_button 'Save stop'
      end
    end
    it 'sends a helpful error message' do
      expect(page).to have_text "Bench can't be blank"
    end
    it 'stays on the edit page' do
      # url doesn't change to edit page
      expect(page).to have_current_path bus_stop_path(edit_stop.hastus_id)
    end
  end
  context 'clicking on the field guide link' do
    before :each do
      within 'table.edit-form' do
        click_on 'Field Guide'
      end
    end
    it 'redirects to the field guide' do
      expect(page).to have_current_path field_guide_bus_stops_path
    end
  end
  context 'with a bus stop that has been previously edited' do
    let!(:last_user) { create :user }
    let!(:user) { create :user }
    let!(:edit_stop) { create :bus_stop }
    it 'displays who updated it and when' do
      Timecop.freeze Date.yesterday do
        when_current_user_is last_user
        visit edit_bus_stop_path(edit_stop.hastus_id)
        within 'table.edit-form' do
          click_button 'Save stop'
        end
      end
      Timecop.freeze Date.today do
        when_current_user_is user
        visit edit_bus_stop_path(edit_stop.hastus_id)
        updated = Date.yesterday.to_formatted_s(:long_with_time)
        expect(page).to have_content "Last updated by #{last_user.name} at #{updated}"
      end
    end
  end
  context 'with a bus stop that has been completed' do
    let!(:last_user) { create :user }
    let!(:user) { create :user }
    let!(:edit_stop) { create :bus_stop, :pending }
    it 'displays who updated it and when' do
      Timecop.freeze Date.yesterday do
        when_current_user_is last_user
        visit edit_bus_stop_path(edit_stop.hastus_id)
        within 'table.edit-form' do
          select 'UMTS', from: 'Garage responsible'
          check 'Completed'
          click_button 'Save stop'
        end
      end
      Timecop.freeze Date.today do
        when_current_user_is user
        visit edit_bus_stop_path(edit_stop.hastus_id)
        completed = Date.yesterday.to_formatted_s(:long_with_time)
        expect(page).to have_content "Completed by #{last_user.name} at #{completed}"
      end
    end
  end
end
