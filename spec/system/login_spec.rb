require 'spec_helper'

describe 'logging in as a user' do
  context 'correct email and password' do
    it 'sends current user to the index' do
    end
    it 'flashes a success message' do
    end
  end
  context 'incorrect email or password' do
    it "doesn't send current user to the index" do
    end
  end
  it 'displays a login notice' do
  end
end

# I don't think this is necessary. We should trust devise.
describe 'logging out as a user' do
  it 'logs current user out' do
  end
  it 'redirects to login page' do
  end
end
