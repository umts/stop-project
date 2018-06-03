require 'spec_helper'

describe 'Logging In' do
  it 'shows the right page' do
    visit root_url
    expect(page).to have_content 'Hello World'
  end
end
