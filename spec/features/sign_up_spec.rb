# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  scenario 'User successfully signs up' do
    fill_in 'Email', with: 'newuser@test.com'
    within '.user_password' do
      fill_in 'Password', with: '123456'
    end
    within '.user_password_confirmation' do
      fill_in 'Password confirmation', with: '123456'
    end
    within('form') { click_on 'Sign up' }

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User unsuccessfully signs up' do
    within('form') { click_on 'Sign up' }

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
