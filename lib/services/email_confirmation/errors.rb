# frozen_string_literal: true

module Services
  module EmailConfirmation
    module Errors
      BaseError      = Class.new(StandardError)
      TokenExpired   = Class.new(BaseError)
      TooManyPerHour = Class.new(BaseError)
    end
  end
end
