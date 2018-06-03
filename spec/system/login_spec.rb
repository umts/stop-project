require 'spec_helper'

# I don't think this is necessary. We should trust devise.
describe 'logging in as a user' do
  let(:user){ create :user, password: 'password', password_confirmation: 'password' }
  context 'correct email and password' do
    before :each do
      when_current_user_is user
      visit root_url
    end
    it 'sends current user to the index' do
      expect(page).to have_text 'Bus Stops'
    end
    it 'flashes a success message' do
    end
  end
  context 'incorrect email or password' do
    before :each do
      when_current_user_is valid_user
      fill_in 'user_email'
    end
    it "doesn't send current user to the index" do
      expect(page).not_to have_text 'Bus Stops'
    end
  end
  it 'displays a login notice' do
  end
end

describe 'logging out as a user' do
  it 'logs current user out' do
  end
  it 'redirects to login page' do
  end
end
