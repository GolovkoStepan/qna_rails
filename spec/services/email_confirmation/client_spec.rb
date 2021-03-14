# frozen_string_literal: true

require 'rails_helper'

describe Services::EmailConfirmation::Client do
  let(:email) { 'test@test.com' }
  let(:redis) { Redis.new }

  before(:each) { described_class.new.reset(email: email) }

  context '#create_token' do
    it 'should generate token and save in redis' do
      token = described_class.new.create_token(email: email)

      expect(redis.get("email_confirmation:#{email}:token")).to eq(token)
      expect(redis.get("email_confirmation:#{email}:counter")).to eq('1')
    end

    it 'should raise TooManyPerHour error' do
      email_confirmation_client = described_class.new

      expect { 11.times { email_confirmation_client.create_token(email: email) } }
        .to raise_error(Services::EmailConfirmation::Errors::TooManyPerHour)
    end
  end

  context '#token_equal?' do
    it 'should check token and return true' do
      email_confirmation_client = described_class.new
      token                     = email_confirmation_client.create_token(email: email)

      expect(email_confirmation_client.token_equal?(email: email, token: token)).to be_truthy
    end

    it 'should check token and return false' do
      email_confirmation_client = described_class.new
      token                     = email_confirmation_client.create_token(email: email)

      expect(email_confirmation_client.token_equal?(email: email, token: "#{token}A")).to be_falsey
    end

    it 'should raise CodeExpired error' do
      email_confirmation_client = described_class.new
      token                     = email_confirmation_client.create_token(email: email)

      redis.expire("email_confirmation:#{email}:token", 1)
      sleep(2)

      expect { email_confirmation_client.token_equal?(email: email, token: token) }
        .to raise_error(Services::EmailConfirmation::Errors::TokenExpired)
    end
  end

  context '#reset' do
    it 'should delete keys for the specified number in redis' do
      email_confirmation_client = described_class.new
      email_confirmation_client.create_token(email: email)

      email_confirmation_client.reset(email: email)

      expect(redis.get("email_confirmation:#{email}:token")).to eq(nil)
      expect(redis.get("email_confirmation:#{email}:counter")).to eq(nil)
    end
  end
end
