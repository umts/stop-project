require 'spec_helper'

describe 'editing a user as an admin' do
  before :each do
    admin = create :user, :admin
    @edit_user = create :user
    
    when_current_user_is admin
    visit edit_user_path(@edit_user)
  end
  context 'with no changes' do
    before :each do
      within 'table.edit-form' do
        click_button 'Save user'
      end
    end
    it 'updates the user' do
      expect(page).to have_selector 'p.notice',
        text: 'User was updated.'
    end
    it 'redirect to users table' do
      expect(page.current_path).to end_with users_path
    end
  end
  context 'with name, email, or admin changes' do
    it 'updates the user and table accordingly' do
    end
  end
end
