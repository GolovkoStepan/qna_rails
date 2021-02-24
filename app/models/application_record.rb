# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.register_changes_tracker_for(*actions)
    Services::ResourceChangesManager::Configuration.register_resource self, actions: actions
  end
end
