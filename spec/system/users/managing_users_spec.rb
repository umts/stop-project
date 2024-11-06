# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'managing users as an admin' do
  let!(:manage_user) { create :user }

  before do
    when_current_user_is :admin
    visit users_path
  end

  describe 'the delete button' do
    subject(:click_delete) do
      within('tr', text: manage_user.name) { click_on 'Delete' }
    end

    it 'deletes the specific user' do
      click_delete
      expect(page).to have_no_css 'table.index tbody tr', text: manage_user.name
    end

    it 'informs you of success' do
      click_delete
      expect(page).to have_css '.alert', text: 'User was deleted.'
    end
  end

  describe 'the edit link' do
    subject(:click_edit) do
      within('tr', text: manage_user.name) { click_on 'Edit' }
    end

    it 'goes to the edit user page' do
      click_edit
      expect(page).to have_current_path(edit_user_path(id: manage_user))
    end
  end
end
