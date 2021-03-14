# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      if (id = cookies.signed['user.id'])
        self.current_user = cached_user_instance(id)
      end

      logger.add_tags 'ActionCable', "Username - #{current_user&.nickname || 'Anonymous'}"
    end

    private

    class << self
      def user(id)
        users[id] ||= User.find_by(id: id)
      end

      def users
        @users ||= {}
      end
    end

    def cached_user_instance(id)
      self.class.user(id)
    end
  end
end
