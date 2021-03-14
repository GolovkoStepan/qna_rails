# frozen_string_literal: true

require 'rails_helper'

class FakeSmsClient
  def send_to(*args)
    args
  end
end

feature 'User can confirm phone number' do
  given(:number) { 79_000_000_000 }
  given(:user)   { create(:user, phone: number, phone_confirmed: false) }
  given(:code)   { '1234' }
  given(:text)   { "Your code for phone confirmation on QNA: #{code}" }

  describe 'When code is valid' do
    background do
      expect(Services::SmsSender::Client).to receive(:new) { FakeSmsClient.new }
      expect_any_instance_of(FakeSmsClient)
        .to receive(:send_to).with(number: number, text: text).and_return({})
      expect_any_instance_of(Services::OneTimePassword::Client)
        .to receive(:create_code).with(number: number).and_return(code)
      expect_any_instance_of(Services::OneTimePassword::Client)
        .to receive(:code_equal?).with(number: number, code: code).and_return(true)

      sign_in(user)
    end

    scenario 'User can create otp request and confirm phone with code', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your phone number is not confirmed!'
      expect(page).to have_link 'Send confirmation code'

      click_on 'Send confirmation code'

      within id: 'phone-confirmation-block' do
        expect(page).to have_content('A confirmation code has been sent to your phone,' \
                                   ' please enter it in the field and click "Check code"')

        fill_in id: 'otp_code_code', with: code
        click_on 'Check code'

        expect(page).to have_content('Phone number is confirmed!')
      end
    end
  end

  describe 'When code is wrong' do
    background do
      expect(Services::SmsSender::Client).to receive(:new) { FakeSmsClient.new }
      expect_any_instance_of(FakeSmsClient)
        .to receive(:send_to).with(number: number, text: text).and_return({})
      expect_any_instance_of(Services::OneTimePassword::Client)
        .to receive(:create_code).with(number: number).and_return(code)
      expect_any_instance_of(Services::OneTimePassword::Client)
        .to receive(:code_equal?).with(number: number, code: code).and_return(false)

      sign_in(user)
    end

    scenario 'User can create otp request and confirm phone with code', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your phone number is not confirmed!'
      expect(page).to have_link 'Send confirmation code'

      click_on 'Send confirmation code'

      within id: 'phone-confirmation-block' do
        expect(page).to have_content('A confirmation code has been sent to your phone,' \
        ' please enter it in the field and click "Check code"')

        fill_in id: 'otp_code_code', with: code
        click_on 'Check code'

        expect(page).to have_content('An error occurred while validating the code.' \
        ' The code is out of date or has not been generated. Or did you enter it wrong? Try again!')
      end
    end
  end

  describe 'When code is expired' do
    background do
      expect(Services::SmsSender::Client).to receive(:new) { FakeSmsClient.new }
      expect_any_instance_of(FakeSmsClient)
        .to receive(:send_to).with(number: number, text: text).and_return({})
      expect_any_instance_of(Services::OneTimePassword::Client)
        .to receive(:create_code).with(number: number).and_return(code)
      expect_any_instance_of(Services::OneTimePassword::Client)
        .to receive(:code_equal?).with(number: number, code: code)
                                 .and_raise(Services::OneTimePassword::Errors::CodeExpired)

      sign_in(user)
    end

    scenario 'User can create otp request and confirm phone with code', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your phone number is not confirmed!'
      expect(page).to have_link 'Send confirmation code'

      click_on 'Send confirmation code'

      within id: 'phone-confirmation-block' do
        expect(page).to have_content('A confirmation code has been sent to your phone,' \
        ' please enter it in the field and click "Check code"')

        fill_in id: 'otp_code_code', with: code
        click_on 'Check code'

        expect(page).to have_content('An error occurred while validating the code.' \
        ' The code is out of date or has not been generated. Or did you enter it wrong? Try again!')
      end
    end
  end

  describe 'When too many otp requests' do
    background do
      expect_any_instance_of(Services::OneTimePassword::Client)
        .to receive(:create_code).with(number: number).and_raise(Services::OneTimePassword::Errors::TooManyPerHour)

      sign_in(user)
    end

    scenario 'User can create otp request and confirm phone with code', js: true do
      visit edit_user_registration_path

      expect(page).to have_content 'Your phone number is not confirmed!'
      expect(page).to have_link 'Send confirmation code'

      click_on 'Send confirmation code'

      within id: 'phone-confirmation-block' do
        expect(page).to have_content('Too many requests for sending codes. Only 5 requests per hour allowed.')
      end
    end
  end
end
