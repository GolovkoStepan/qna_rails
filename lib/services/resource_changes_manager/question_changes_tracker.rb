# frozen_string_literal: true

class Services::ResourceChangesManager::QuestionChangesTracker
  class << self
    def create(question)
      html = ApplicationController.render(partial: 'questions/question', locals: { question: question })
      ActionCable.server.broadcast('questions_changes_channel', { action: 'create', template: html })
    end
  end
end
