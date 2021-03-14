# frozen_string_literal: true

module Services
  module EmailConfirmation
    class Client
      KEY_PREFIX   = 'email_confirmation'
      TOKEN_TTL    = 2.days.in_seconds
      COUNTER_TTL  = 1.hour.in_seconds
      MAX_PER_HOUR = 10

      include Services::EmailConfirmation::Errors

      def initialize(redis: nil)
        @redis = redis || Redis.new
      end

      def create_token(email:)
        log("Create token for #{email}")

        generate_token.tap do |token|
          counter_key = counter_key(email)
          token_key   = token_key(email)

          rescue_redis_errors do
            counter = redis.get(counter_key)
            raise TooManyPerHour if counter.present? && counter.to_i >= MAX_PER_HOUR

            counter.present? ? redis.incr(counter_key) : redis.setex(counter_key, COUNTER_TTL, '1')
            redis.setex(token_key, TOKEN_TTL, token)
          end

          log("Token for #{email} created successfully: [#{token}]")
        end
      end

      def token_equal?(email:, token:)
        log("Check [#{token}] token for #{email}")

        token_key = token_key(email)
        rescue_redis_errors do
          stored_token = redis.get(token_key)
          raise TokenExpired if stored_token.nil?

          (stored_token == token).tap do |result|
            log("Token [#{token}] check result: #{result}")
          end
        end
      end

      def reset(email:)
        redis.del(counter_key(email), token_key(email))
        log("Keys for #{email} are removed")
      end

      private

      attr_reader :redis

      def rescue_redis_errors
        yield
      rescue Redis::BaseError => e
        log("Redis error: #{e.inspect}")
        false
      end

      def generate_token
        SecureRandom.alphanumeric(50)
      end

      def token_key(email)
        [KEY_PREFIX, email, 'token'].join(':')
      end

      def counter_key(email)
        [KEY_PREFIX, email, 'counter'].join(':')
      end

      def log(msg)
        Rails.logger.tagged('Email Confirmation') do
          Rails.logger.info(msg)
        end
      end
    end
  end
end
