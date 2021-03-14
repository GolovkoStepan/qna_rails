# frozen_string_literal: true

module Services
  module OneTimePassword
    module Errors
      BaseError      = Class.new(StandardError)
      CodeExpired    = Class.new(BaseError)
      TooManyPerHour = Class.new(BaseError)
    end
  end
end
