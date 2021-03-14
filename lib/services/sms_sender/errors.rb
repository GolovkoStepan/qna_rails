# frozen_string_literal: true

module Services
  module SmsSender
    module Errors
      BaseError = Class.new(StandardError)
      AuthError = Class.new(BaseError)
    end
  end
end
