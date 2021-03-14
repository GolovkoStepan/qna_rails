# frozen_string_literal: true

require 'rails_helper'

describe Services::SmsSender::Client do
  context 'should create class instance without errors' do
    let(:auth_valid_response) do
      {
        'success' => true,
        'data' => nil,
        'message' => 'Successful authorization.'
      }
    end

    before do
      stub_request(:post, "#{ENV['SMS_SENDER_API_BASE_URL']}auth")
        .with(basic_auth: [ENV['SMS_SENDER_API_USERNAME'], ENV['SMS_SENDER_API_PASSWORD']])
        .to_return(body: auth_valid_response.to_json)
    end

    it { expect { described_class.new }.to_not raise_error }
  end

  context 'should raise auth error on creation class instance' do
    before do
      stub_request(:post, "#{ENV['SMS_SENDER_API_BASE_URL']}auth")
        .with(basic_auth: [ENV['SMS_SENDER_API_USERNAME'], ENV['SMS_SENDER_API_PASSWORD']])
        .to_raise(RestClient::Unauthorized)
    end

    it { expect { described_class.new }.to raise_error(Services::SmsSender::Errors::AuthError) }
  end

  context '#current_account_balance returns current balance' do
    let(:balance) { '543.23' }
    let(:auth_valid_response) do
      {
        'success' => true,
        'data' => nil,
        'message' => 'Successful authorization.'
      }
    end
    let(:response) do
      {
        'success' => true,
        'data' => {
          'balance' => balance
        },
        'message' => nil
      }
    end

    before do
      stub_request(:post, "#{ENV['SMS_SENDER_API_BASE_URL']}auth")
        .with(basic_auth: [ENV['SMS_SENDER_API_USERNAME'], ENV['SMS_SENDER_API_PASSWORD']])
        .to_return(body: auth_valid_response.to_json)

      stub_request(:post, "#{ENV['SMS_SENDER_API_BASE_URL']}balance")
        .with(basic_auth: [ENV['SMS_SENDER_API_USERNAME'], ENV['SMS_SENDER_API_PASSWORD']])
        .to_return(body: response.to_json)
    end

    it { expect(described_class.new.current_account_balance).to eq(balance) }
  end

  context '#send_to will make request with right params' do
    let(:number) { '79000000000' }
    let(:text)   { 'some_sms_text' }
    let(:request_body) do
      {
        number: number,
        text: text,
        sign: ENV['SMS_SENDER_API_SIGN']
      }
    end
    let(:auth_valid_response) do
      {
        'success' => true,
        'data' => nil,
        'message' => 'Successful authorization.'
      }
    end
    let(:response) do
      {
        'success' => true,
        'data' => {
          'id' => 298_008_558,
          'from' => 'SMS Aero',
          'number' => number,
          'text' => text,
          'extendStatus' => 'moderation',
          'channel' => 'FREE SIGN',
          'cost' => 2.99,
          'dateCreate' => 1_615_120_538,
          'dateSend' => 1_615_120_538
        },
        'message' => nil
      }
    end

    before do
      stub_request(:post, "#{ENV['SMS_SENDER_API_BASE_URL']}auth")
        .with(basic_auth: [ENV['SMS_SENDER_API_USERNAME'], ENV['SMS_SENDER_API_PASSWORD']])
        .to_return(body: auth_valid_response.to_json)

      stub_request(:post, "#{ENV['SMS_SENDER_API_BASE_URL']}sms/send")
        .with(
          basic_auth: [ENV['SMS_SENDER_API_USERNAME'], ENV['SMS_SENDER_API_PASSWORD']],
          body: request_body
        )
        .to_return(body: response.to_json)
    end

    it { expect(described_class.new.send_to(number: number, text: text)).to eq(response) }
  end
end
