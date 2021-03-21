# frozen_string_literal: true

module Services
  module Omniauth
    class Vkontakte < BaseClient
      def parse_auth_params(params)
        {
          provider: params['provider'],
          uid: params['uid'],
          first_name: params.dig('info', 'first_name'),
          last_name: params.dig('info', 'last_name'),
          email: params.dig('info', 'email'),
          url: params.dig('info', 'urls', 'Vkontakte')
        }
      end
    end
  end
end
