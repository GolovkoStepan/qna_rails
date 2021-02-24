# frozen_string_literal: true

class Services::ResourceChangesManager::Configuration
  class << self
    attr_accessor :resources

    def register_resource(klass, actions: %i[create update destroy])
      klass.class_eval do
        actions.each do |action|
          send "after_#{action}" do
            Rails.logger.info("This #{self.class} #{action} is tracked by ResourceChangesManager service")
            action_handler = "Services::ResourceChangesManager::#{self.class}ChangesTracker"
            Rails.logger.info("Processing by #{action_handler}##{action}")
            action_handler.constantize.send(action, self)
          rescue StandardError => e
            Rails.logger.info("ResourceChangesManager service error on processing: #{e.message}")
          end
        end
      end
    end
  end
end
