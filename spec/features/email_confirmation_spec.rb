# frozen_string_literal: true

require 'rails_helper'

feature 'User can confirm email address' do
  given(:email)             { "test-#{rand(10)}@test.com" }
  given(:user)              { create(:user, email: email, email_confirmed: false) }
  given(:token)             { SecureRandom.alphanumeric(30) }
  given(:check_token_url)   { "http://localhost:3000/users/check_token?token=#{token}" }

  describe 'When token is valid' do
    background do
      expect_any_instance_of(Services::EmailConfirmation::Client)
        .to receive(:create_token).and_return(token)
      expect_any_instance_of(Services::EmailConfirmation::Client)
        .to receive(:token_equal?).and_return(true)

      sign_in(user)
    end

    scenario 'User can create email confirmation request', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your email address is not confirmed!'
      expect(page).to have_link 'Send confirmation email'

      clear_emails

      click_on 'Send confirmation email'

      expect(page).to have_content 'A confirmation link has been sent to your email. Please check.'

      open_email(email)

      expect(current_email).to have_link 'Confirm email address',
                                         href: check_token_url

      visit email_confirmation_check_token_path(params: { token: token })

      expect(page).to have_content 'You email address is confirmed!'
      expect(page).to have_content 'Email is confirmed!'

      expect(user.reload.email_confirmed).to be_truthy
    end
  end

  describe 'When token is wrong' do
    background do
      expect_any_instance_of(Services::EmailConfirmation::Client)
        .to receive(:create_token).and_return(token)
      expect_any_instance_of(Services::EmailConfirmation::Client)
        .to receive(:token_equal?).and_return(false)

      sign_in(user)
    end

    scenario 'User can create email confirmation request', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your email address is not confirmed!'
      expect(page).to have_link 'Send confirmation email'

      clear_emails

      click_on 'Send confirmation email'

      expect(page).to have_content 'A confirmation link has been sent to your email. Please check.'

      open_email(email)

      expect(current_email).to have_link 'Confirm email address',
                                         href: check_token_url

      visit email_confirmation_check_token_path(params: { token: token })

      expect(page).to have_content 'Invalid confirmation token!'

      expect(user.reload.email_confirmed).to be_falsey
    end
  end

  describe 'When token is expired' do
    background do
      expect_any_instance_of(Services::EmailConfirmation::Client)
        .to receive(:create_token).and_return(token)
      expect_any_instance_of(Services::EmailConfirmation::Client)
        .to receive(:token_equal?).and_raise(Services::EmailConfirmation::Errors::TokenExpired)

      sign_in(user)
    end

    scenario 'User can create email confirmation request', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your email address is not confirmed!'
      expect(page).to have_link 'Send confirmation email'

      clear_emails

      click_on 'Send confirmation email'

      expect(page).to have_content 'A confirmation link has been sent to your email. Please check.'

      open_email(email)

      expect(current_email).to have_link 'Confirm email address',
                                         href: check_token_url

      visit email_confirmation_check_token_path(params: { token: token })

      expect(page).to have_content 'Email confirmation token is expired!'

      expect(user.reload.email_confirmed).to be_falsey
    end
  end

  describe 'When too many email confirmation requests' do
    background do
      expect_any_instance_of(Services::EmailConfirmation::Client)
        .to receive(:create_token).and_raise(Services::EmailConfirmation::Errors::TooManyPerHour)

      sign_in(user)
    end

    scenario 'User can create email confirmation request', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your email address is not confirmed!'
      expect(page).to have_link 'Send confirmation email'

      clear_emails

      click_on 'Send confirmation email'

      expect(page).to have_content 'Too many requests for sending codes. Only 5 requests per hour allowed.'
    end
  end
end
