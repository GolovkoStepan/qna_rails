# frozen_string_literal: true

require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module QnaRails
  class Application < Rails::Application
    config.load_defaults 6.0

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    config.time_zone = 'Europe/Moscow'

    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework :rspec, view_specs: false, helper_specs: false, routing_specs: false, request_specs: false
    end
  end
end
