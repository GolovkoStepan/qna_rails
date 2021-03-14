# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhoneConfirmationController, type: :controller do
  let(:number) { 79_000_000_000 }
  let(:user)   { create :user, phone: number }

  before { login(user) }

  describe '#send_otp' do
    let(:code) { 1234 }
    let(:text) { "Your code for phone confirmation on QNA: #{code}" }
    let(:auth_valid_response) do
      {
        'success' => true,
        'data' => nil,
        'message' => 'Successful authorization.'
      }
    end

    context 'when everything is ok' do
      before do
        stub_request(:post, "#{ENV['SMS_SENDER_API_BASE_URL']}auth")
          .with(basic_auth: [ENV['SMS_SENDER_API_USERNAME'], ENV['SMS_SENDER_API_PASSWORD']])
          .to_return(body: auth_valid_response.to_json)

        expect_any_instance_of(Services::OneTimePassword::Client)
          .to receive(:create_code).with(number: number).and_return(code)

        expect_any_instance_of(Services::SmsSender::Client)
          .to receive(:send_to).with(number: number, text: text).and_return({})
      end

      it 'should set result to true' do
        get :send_otp, xhr: true
        expect(assigns(:result)).to be_truthy
      end
    end

    context 'when too many request' do
      before do
        expect_any_instance_of(Services::OneTimePassword::Client)
          .to receive(:create_code).with(number: number).and_raise(Services::OneTimePassword::Errors::TooManyPerHour)
      end

      it 'should set result to false' do
        get :send_otp, xhr: true
        expect(assigns(:result)).to be_falsey
      end
    end
  end

  describe '#check_otp' do
    let(:code) { 1234 }

    context 'when everything is ok' do
      before do
        expect_any_instance_of(Services::OneTimePassword::Client)
          .to receive(:code_equal?).with(number: number, code: code.to_s)
                                   .and_return(true)
      end

      it 'should set result to true' do
        get :check_otp, params: { otp_code: { code: code.to_s } }, xhr: true
        expect(assigns(:result)).to be_truthy
        expect(user.reload.phone_confirmed).to be_truthy
      end
    end

    context 'when code is wrong' do
      before do
        expect_any_instance_of(Services::OneTimePassword::Client)
          .to receive(:code_equal?).with(number: number, code: code.to_s)
                                   .and_return(false)
      end

      it 'should set result to true' do
        get :check_otp, params: { otp_code: { code: code.to_s } }, xhr: true
        expect(assigns(:result)).to be_falsey
        expect(user.reload.phone_confirmed).to be_falsey
      end
    end

    context 'when code is expired' do
      before do
        expect_any_instance_of(Services::OneTimePassword::Client)
          .to receive(:code_equal?).with(number: number, code: code.to_s)
                                   .and_raise(Services::OneTimePassword::Errors::CodeExpired)
      end

      it 'should set result to true' do
        get :check_otp, params: { otp_code: { code: code.to_s } }, xhr: true
        expect(assigns(:result)).to be_falsey
        expect(user.reload.phone_confirmed).to be_falsey
      end
    end
  end
end
