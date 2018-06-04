require 'spec_helper'

describe 'managing stops as an admin' do
  before :each do
    admin = create :user, :admin
    @bus_stop = create :bus_stop
    
    when_current_user_is admin
    visit manage_bus_stops_url
  end
  context 'delete button' do
    it 'deletes the specific bus stop' do
      expect(page).to have_selector 'table.manage tbody tr', count: 1
      within 'tr', text: @bus_stop.name do
        click_button 'Delete'
      end
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector 'p.notice',
        text: "#{@bus_stop.name} has been deleted."
      expect(page).not_to have_selector 'table.manage tbody tr', text: @bus_stop.name
    end
  end
  context 'edit button' do
    it 'redirects to edit bus stop page' do
      expect(page).to have_selector 'table.manage tbody tr', count: 1
      within 'tr', text: @bus_stop.name do
        click_link 'Edit'
      end
      expect(page).to have_content "Editing #{@bus_stop.name}"
      expect(page.current_url).to end_with edit_bus_stop_path(@bus_stop.hastus_id)
    end
  end
end

describe 'viewing outdated' do
  context 'click the link' do
    it 'redirects to outdated page' do
      click_link 'View Outdated'
      expect(page.current_url).to end_with outdated_bus_stops_path
    end
    it 'allows editing of outdated stops' do
    end
    it 'outdated can be narrowed down with a different date' do
    end
  end
end

describe 'exporting all as CSV' do
  it 'exports a CSV of all stops' do
  end
end
