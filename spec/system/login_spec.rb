require 'spec_helper'

describe 'Logging In' do
  before do
    driven_by :selenium_chrome_headless
  end
  
  it 'shows the right page' do
    visit root_url
    expect(page).to have_content 'Hello World'
  end
end
