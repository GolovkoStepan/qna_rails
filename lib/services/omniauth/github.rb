# frozen_string_literal: true

module Services
  module Omniauth
    class Github < BaseClient
      def parse_auth_params(params)
        {
          provider: params['provider'],
          uid: params['uid'],
          nickname: params.dig('info', 'nickname'),
          email: params.dig('info', 'email'),
          url: params.dig('info', 'urls', 'GitHub')
        }
      end
    end
  end
end
