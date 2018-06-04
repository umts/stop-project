require 'spec_helper'

describe 'creating users as an admin' do
  before :each do
    admin = create :user, :admin
    when_current_user_is admin
    visit new_user_url
  end
  context 'with all fields' do
    before :each do
      expect(page).to have_text 'New User'
      within 'form#new_user.new_user' do
        fill_in 'Name', with: 'Ben K'
        fill_in 'Email', with: 'ben@example.com'
        check 'Admin'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'

        click_on 'Save user'
      end
    end
    it 'notifies the user has been created' do
      expect(page).to have_selector 'p.notice',
        text: 'User was created.'
    end
    it 'redirects to the users page' do
      expect(page.current_url).to end_with users_path
    end
  end
   context 'without name and email' do
     before :each do
        within 'form#new_user.new_user' do
          check 'Admin'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'

          click_on 'Save user'
        end
     end
     it "doesn't create a new user" do
       expect(page).not_to have_text 'User was created.'
     end
     it 'stays on the new user page' do
       expect(page.current_url).to end_with new_user_path
     end
   end
   context 'without password' do
     it 'creates the user' do
       within 'form#new_user.new_user' do
         fill_in 'Name', with: 'Adam'
         fill_in 'Email', with: 'adam@example.com'
         check 'Admin'
         fill_in 'Password confirmation', with: 'password'
         
         click_on 'Save user'
       end
       expect(page).to have_selector 'p.notice',
         text: 'User was created.'
       expect(page.current_url).to end_with users_path
     end
   end
end
