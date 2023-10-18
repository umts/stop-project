# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'editing a user as an admin' do
  subject(:click_save) { click_button 'Save user' }

  let(:admin) { create :user, :admin }
  let(:edit_user) { create :user }

  before do
    when_current_user_is admin
    visit edit_user_path(edit_user)
  end

  context 'with no changes' do
    it 'updates the user' do
      click_save
      expect(page).to have_selector 'p.notice', text: 'User was updated.'
    end

    it 'redirect to users table' do
      click_save
      expect(page.current_url).to end_with users_path
    end
  end

  context 'with changes' do
    let(:user_row) do
      # Find the tr that has a link to the edit path for that user in it
      page.find(:xpath, "//tr[.//a[@href='#{edit_user_path(edit_user)}']]")
    end

    before do
      fill_in 'Name', with: 'newname'
      fill_in 'Email', with: 'newemail@example.com'
      check 'Admin'
      fill_in 'Password', with: 'newpass!834'
      fill_in 'Password confirmation', with: 'newpass!834'
    end

    it "updates the user's name" do
      click_save
      within(user_row) { expect(page).to have_text('newname') }
    end

    it "updates the user's email" do
      click_save
      within(user_row) { expect(page).to have_text('newemail@example.com') }
    end

    it "updates the user's admin status" do
      click_save
      within(user_row) { expect(page).to have_text('Yes') }
    end
  end

  context 'with errors' do
    before do
      fill_in 'Name', with: admin.name
    end

    it 'sends a helpful error message' do
      click_save
      expect(page).to have_selector 'p.errors', text: 'Name has already been taken'
    end

    it 'stays on the edit page' do
      click_save
      expect(page).to have_current_path(user_path(id: edit_user))
    end
  end
end
