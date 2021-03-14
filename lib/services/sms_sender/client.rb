# frozen_string_literal: true

module Services
  module SmsSender
    class Client
      API_AUTH_USERNAME = ENV['SMS_SENDER_API_USERNAME']
      API_AUTH_PASSWORD = ENV['SMS_SENDER_API_PASSWORD']
      API_SIGN          = ENV['SMS_SENDER_API_SIGN']
      API_BASE_URL      = ENV['SMS_SENDER_API_BASE_URL']

      include ::Services::SmsSender::Errors

      def initialize(username: nil, password: nil, sign: nil)
        @auth_username = username || API_AUTH_USERNAME
        @auth_password = password || API_AUTH_PASSWORD
        @sign          = sign || API_SIGN

        raise AuthError unless valid_authorization?
      end

      def send_to(number:, text:)
        log("Send sms to #{number}, text: #{text}")

        payload  = { sign: sign, number: number.to_s, text: text }
        response = make_request(url: api_url('sms/send'), payload: payload)

        result = parse_response(response)
        log("Request complete: #{result}")

        result
      end

      def current_account_balance
        log('Start balance request')

        response = make_request(url: api_url('balance'))
        result   = parse_response(response)
        log("Request complete: #{result}")

        result.dig('data', 'balance')
      end

      private

      attr_reader :auth_username, :auth_password, :sign

      def api_url(path)
        "#{API_BASE_URL}#{path}"
      end

      def make_request(url:, payload: {})
        RestClient.post(
          url,
          payload,
          { Authorization: "Basic #{Base64.strict_encode64("#{auth_username}:#{auth_password}")}" }
        )
      end

      def parse_response(response)
        JSON.parse(response.body)
      end

      def valid_authorization?
        response = make_request url: api_url('auth')
        result   = parse_response response

        result['message'] == 'Successful authorization.'
      rescue RestClient::Unauthorized
        false
      end

      def log(msg)
        Rails.logger.tagged('Sms Sender') do
          Rails.logger.info(msg)
        end
      end
    end
  end
end
