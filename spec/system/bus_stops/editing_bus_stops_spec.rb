
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
    it 'updates the stop' do
      expect(page).to have_selector 'p.notice',
                                    text: 'Bus stop was updated.'
    end
    it 'redirects to the bus stops page' do
      expect(page.current_url).to end_with bus_stops_path
    end
  end
  context 'with data changes' do
    before :each do
      within 'table.edit-form' do
        select 'UMTS', from: 'Garage responsible'
        click_button 'Save stop'
      end
    end
    it 'updates the stop' do
      expect(page).to have_selector 'p.notice',
                                    text: 'Bus stop was updated.'
    end
    it 'redirects to the bus stops page' do
      expect(page.current_url).to end_with bus_stops_path
    end
  end
  #this context block is failing. TODO: figure out why
  context 'with errors' do
    before :each do
      within 'table.edit-form' do
        check 'Completed'
        click_button 'Save stop'
      end
    end
    it 'sends a helpful error message' do
      expect(page).to have_selector 'p.error',
                                    text: "Bench can't be blank"
    end
    it 'stays on the edit page' do
      expect(page).to have_current_path(edit_bus_stop_path(edit_stop.hastus_id))
    end
  end
  context 'clicking on the field guide link' do
    before :each do
      within 'table.edit-form' do
        click_on 'Field Guide'
      end
    end
    it 'redirects to the field guide' do
      expect(page.current_url).to end_with field_guide_bus_stops_path
    end
  end
end
