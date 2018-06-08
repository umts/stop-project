# frozen_string_literal: true

require 'spec_helper'

describe 'managing users as an admin' do
  let(:admin) { create :user, :admin }
  let!(:manage_user) { create :user }
  before :each do
    when_current_user_is admin
    visit users_url
  end
  context 'delete button' do
    it 'deletes the specific user' do
      expect(page).to have_selector 'table.index tbody tr', count: 2
      within 'tr', text: manage_user.name do
        click_button 'Delete'
      end
      expect(page).to have_selector 'p.notice',
                                    text: 'User was deleted.'
      expect(page).not_to have_selector 'table.index tbody tr', text: manage_user.name
    end
  end
  context 'edit button' do
    it 'redirects to edit user page' do
      expect(page).to have_selector 'table.index tbody tr', count: 2
      within 'tr', text: manage_user.name do
        click_button 'Edit'
      end
      expect(page).to have_content "Editing #{manage_user.name}"
    end
  end
end
