# frozen_string_literal: true

require 'spec_helper'

describe 'editing a user as an admin' do
  let!(:admin) { create :user, :admin }
  let!(:edit_user) { create :user }
  before :each do
    when_current_user_is admin
    visit edit_user_path(edit_user)
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
      expect(page.current_url).to end_with users_path
    end
  end
  context 'with name, email, or admin changes' do
    it 'updates the user and table accordingly' do
      previous_name = edit_user.name
      previous_email = edit_user.email
      within 'table.edit-form' do
        fill_in 'Name', with: 'newname'
        fill_in 'Email', with: 'newemail@example.com'
        check 'Admin'
        fill_in 'Password', with: 'newpass!834'
        fill_in 'Password confirmation', with: 'newpass!834'
        click_button 'Save user'
      end
      expect(page).to have_css 'td', text: 'newname'
      expect(page).to have_css 'td', text: 'newemail@example.com'
      # users in table are all admins
      expect(page).to have_css '.glyphicon-ok'
      expect(page).not_to have_css 'td', text: previous_name
      expect(page).not_to have_css 'td', text: previous_email
      expect(page).not_to have_css '.glyphicon-remove'
    end
  end
  context 'with errors' do
    before :each do
      within 'table.edit-form' do
        fill_in 'Name', with: admin.name
        click_button 'Save user'
      end
    end
    it 'sends a helpful error message' do
      expect(page).to have_selector 'p.errors',
                                    text: 'Name has already been taken'
    end
    it 'stays on the edit page' do
      expect(page).to have_current_path(user_path(id: edit_user))
    end
  end
end
