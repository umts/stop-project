require 'spec_helper'

describe 'editing a user as an admin' do
  before :each do
    admin = create :user, :admin
    edit_user = create :user
    
    when_current_user_is admin
    visit edit_user, id: edit_user.id
  end
end
