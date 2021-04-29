# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'creating users as an admin' do
  subject(:click_save) { click_on 'Save user' }

  let(:admin) { create :user, :admin }

  before do
    when_current_user_is admin
    visit new_user_path
  end

  it 'says it is the new user page' do
    expect(page).to have_text 'New User'
  end

  context 'with all fields filled in' do
    before do
      fill_in 'Name', with: 'Ben K'
      fill_in 'Email', with: 'ben@example.com'
      check 'Admin'
      fill_in 'Password', with: 'password$367'
      fill_in 'Password confirmation', with: 'password$367'
    end

    it 'notifies the user has been created' do
      click_save
      expect(page).to have_selector 'p.notice', text: 'User was created.'
    end

    it 'redirects to the users page' do
      click_save
      expect(page).to have_current_path users_path
    end
  end

  context 'with errors' do
    before do
      check 'Admin'
      fill_in 'Name', with: 'someone'
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
    end

    it 'sends a helpful error message' do
      click_save
      expect(page).to have_selector 'p.errors', text: 'Email has already been taken'
    end

    it 'redirects to edit user page' do
      click_save
      expect(page).to have_current_path users_path
    end

    it 'keeps valid submitted data' do
      click_save
      expect(page).to have_field('Name', with: 'someone')
    end

    it 'keeps invalid submitted data' do
      click_save
      expect(page).to have_field('Email', with: admin.email)
    end
  end

  context "when the password and password confirmation don't match" do
    before do
      check 'Admin'
      fill_in 'Name', with: 'Brody'
      fill_in 'Email', with: 'brody@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password7'
    end

    it 'sends a helpful error message' do
      click_save
      expect(page)
        .to have_selector 'p.errors', text: "Password confirmation doesn't match Password"
    end

    it 'redirects to edit user page' do
      click_save
      expect(page).to have_current_path users_path
    end

    it 'keeps submitted data' do
      click_save
      expect(page).to have_field('Name', with: 'Brody')
    end
  end
end
