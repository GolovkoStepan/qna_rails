# frozen_string_literal: true

module Services
  module OneTimePassword
    class Client
      CODE_TTL     = 5.minutes.in_seconds
      COUNTER_TTL  = 1.hour.in_seconds
      MAX_PER_HOUR = 5
      KEY_PREFIX   = 'otp'

      include Services::OneTimePassword::Errors

      def initialize(redis: nil)
        @redis = redis || Redis.new
      end

      def create_code(number:)
        log("Create code for #{number}")

        generate_code.tap do |code|
          counter_key = counter_key(number)
          code_key    = code_key(number)

          rescue_redis_errors do
            counter = redis.get(counter_key)
            raise TooManyPerHour if counter.present? && counter.to_i >= MAX_PER_HOUR

            counter.present? ? redis.incr(counter_key) : redis.setex(counter_key, COUNTER_TTL, '1')
            redis.setex(code_key, CODE_TTL, code)
          end

          log("Code for #{number} created successfully: [#{code}]")
        end
      end

      def code_equal?(number:, code:)
        log("Check [#{code}] code for #{number}")

        code_key = code_key(number)
        rescue_redis_errors do
          stored_code = redis.get(code_key)
          raise CodeExpired if stored_code.nil?

          (stored_code.to_s == code.to_s.rjust(4, '0')).tap do |result|
            log("Code [#{code}] check result: #{result}")
          end
        end
      end

      def reset(number:)
        redis.del(counter_key(number), code_key(number))
        log("Keys for #{number} are removed")
      end

      private

      attr_reader :redis

      def rescue_redis_errors
        yield
      rescue Redis::BaseError => e
        log("Redis error: #{e.inspect}")
        false
      end

      def generate_code
        rand(0o000..9999).to_s.rjust(4, '0')
      end

      def code_key(number)
        [KEY_PREFIX, number, 'code'].join(':')
      end

      def counter_key(number)
        [KEY_PREFIX, number, 'counter'].join(':')
      end

      def log(msg)
        Rails.logger.tagged('OTP') do
          Rails.logger.info(msg)
        end
      end
    end
  end
end
