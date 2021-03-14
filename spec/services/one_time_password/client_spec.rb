# frozen_string_literal: true

require 'rails_helper'

describe Services::OneTimePassword::Client do
  let(:number) { 79_000_000_000 }
  let(:redis)  { Redis.new }

  before(:each) { described_class.new.reset(number: number) }

  context '#create_code' do
    it 'should generate code and save in redis' do
      code = described_class.new.create_code(number: number)

      expect(code.length).to eq(4)
      expect(redis.get("otp:#{number}:code")).to eq(code)
      expect(redis.get("otp:#{number}:counter")).to eq('1')
    end

    it 'should raise TooManyPerHour error' do
      otp_client = described_class.new

      expect { 6.times { otp_client.create_code(number: number) } }
        .to raise_error(Services::OneTimePassword::Errors::TooManyPerHour)
    end
  end

  context '#code_equal?' do
    it 'should check code and return true' do
      otp_client = described_class.new
      code       = otp_client.create_code(number: number)

      expect(otp_client.code_equal?(number: number, code: code)).to be_truthy
    end

    it 'should check code and return false' do
      otp_client = described_class.new
      code       = otp_client.create_code(number: number)

      expect(otp_client.code_equal?(number: number, code: code.to_i + 1)).to be_falsey
    end

    it 'should raise CodeExpired error' do
      otp_client = described_class.new
      code       = otp_client.create_code(number: number)

      redis.expire("otp:#{number}:code", 1)
      sleep(2)

      expect { otp_client.code_equal?(number: number, code: code) }
        .to raise_error(Services::OneTimePassword::Errors::CodeExpired)
    end
  end

  context '#reset' do
    it 'should delete keys for the specified number in redis' do
      otp_client = described_class.new
      otp_client.create_code(number: number)

      otp_client.reset(number: number)

      expect(redis.get("otp:#{number}:code")).to eq(nil)
      expect(redis.get("otp:#{number}:counter")).to eq(nil)
    end
  end
end
