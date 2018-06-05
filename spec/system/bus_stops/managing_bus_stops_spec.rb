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
  before :each do
    admin = create :user, :admin
    @present_stop = create :bus_stop
    @date = Date.today
    @stop_1 = create :bus_stop, updated_at: (@date - 2.months)
    @stop_2 = create :bus_stop, updated_at: (@date - 3.months)
    when_current_user_is admin
    visit manage_bus_stops_url

    click_link 'View Outdated'
  end
  it 'redirects to outdated page' do
    expect(page.current_url).to end_with outdated_bus_stops_path
  end
  it 'displays only outdated stops' do
    expect(page).to have_selector 'table.manage tbody tr', count: 2
    expect(page).to have_selector 'table.manage tbody tr', text: @stop_1.name
    expect(page).to have_selector 'table.manage tbody tr', text: @stop_2.name
  end
  it 'allows editing of outdated stops' do
    within 'tr', text: @stop_1.hastus_id do
      click_link 'Edit'
    end
    expect(page).to have_content "Editing #{@stop_1.name}"
  end
  it 'outdated can be narrowed down with a different date' do
    pending('review datepickers and capybara')
  end
end

describe 'exporting all as CSV' do
  it 'exports a CSV of all stops' do
    pending('maybe later')
  end
end
