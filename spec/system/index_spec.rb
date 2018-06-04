require 'spec_helper'

describe 'searching for a bus stop by stop id' do
  before :each do
    user = create :user
    when_current_user_is user
    visit root_url
    @bus_stop = create :bus_stop
  end
  context 'correct stop id' do
    it 'redirects to the edit page' do
      within 'form', text: 'Enter stop ID' do
        fill_in 'id', with: @bus_stop.id
        click_button 'Search'
      end
    end
  end
   context 'incorrect stop id' do
     before :each do
       within 'form', text: 'Enter stop ID' do
         fill_in 'id', with: -@bus_stop.id
         click_button 'Search'
       end
     end
     it 'stays on the same page' do
       expect(page.current_url).to match root_path
     end
     it 'displays a helpful message' do
       expect(page).to have_selector 'p.notice',
         text: "Stop #{-@bus_stop.id} not found"
     end
   end
end

describe 'searching for a bus stop by stop name' do
  context 'correct stop name' do
    it 'redirects to the edit page' do
    end
  end
  context 'incorrect stop name' do
    it 'stays on the same page' do
    end
    it 'displays a helpful message' do
    end
  end
end

describe 'searching for a bus stop by route' do
  context 'route from the dropdown' do
    it 'redirects to bus stops by route page' do
    end
  end
end

