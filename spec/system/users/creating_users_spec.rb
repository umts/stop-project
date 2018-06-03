require 'spec_helper'

describe 'creating users' do
  before :each do
    admin = create :user, :admin
    when_current_user_is admin
    visit new_user_url
  end
  context 'as an admin' do
    it 'creates a user' do
    end
    it 'notifies you the user has been created' do
    end
    it 'redirects you to the users page' do
    end
  end
  context 'as a regular user' do
  end
end
