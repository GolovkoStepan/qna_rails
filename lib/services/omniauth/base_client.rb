# frozen_string_literal: true

module Services
  module Omniauth
    class BaseClient
      attr_reader :auth_params

      def initialize(omniauth_params)
        @auth_params = parse_auth_params(omniauth_params)
      end

      def find_or_create_user
        log("Start to find provider for uid: #{auth_params[:uid]}.")
        oauth_provider = OauthProvider.find_by(uid: auth_params[:uid], provider: auth_params[:provider])

        # Если провайдер есть, то вернуть пользователя и выйти
        if oauth_provider.present?
          user = oauth_provider.user
          log("Provider found. Continue with user, id: #{user.id}.")
          return user
        end

        # Провайдера нет. Попробовать найти пользователя по email
        log('Provider not found. Start to find user.')
        user = User.find_by(email: auth_params[:email])

        if user.present?
          log("User with email: #{user.email} found.")
          # Если email был подтвержден, то добавляем провайдер для этого пользователя
          if user.email_confirmed
            create_provider(user)
            log("Provider created. Continue with user, id: #{user.id}.")
            return user
          end

          # Возможно, емайл был указан по ошибке.
          # Мы не уверены, что этот пользователь владелец этого email.
          log('Email is not confirmed. Create new user.')
          user.update(email: '') # Занулить email у найденного пользователя
        end

        # Создать нового пользователя и провайдер для него
        user = create_user
        user.update(email_confirmed: true) if user.email?
        create_provider(user)
        log("Provider created. Continue with user, id: #{user.id}.")
        user
      end

      protected

      def parse_auth_params(_)
        raise NotImplementedError
      end

      private

      def create_user(nickname = auth_params[:nickname], retry_count = 1)
        log("Trying to create user with #{retry_count} attempt")
        password = SecureRandom.alphanumeric(20)
        User.create!(
          nickname: nickname || SecureRandom.alphanumeric(10),
          email: (auth_params[:email] || ''),
          first_name: auth_params[:first_name],
          last_name: auth_params[:last_name],
          password: password,
          password_confirmation: password
        )
      rescue StandardError
        create_user(SecureRandom.alphanumeric(10), retry_count + 1) if retry_count < 10
      end

      def create_provider(user)
        log("Creating provider for uid: #{auth_params[:uid]}")
        OauthProvider.create(
          uid: auth_params[:uid],
          provider: auth_params[:provider],
          url: auth_params[:url],
          user: user
        )
      end

      def log(msg)
        Rails.logger.tagged("Omniauth #{self.class.name.demodulize} Service") do
          Rails.logger.info(msg)
        end
      end
    end
  end
end
