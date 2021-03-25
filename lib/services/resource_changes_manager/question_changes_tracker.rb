# frozen_string_literal: true

class Services::ResourceChangesManager::QuestionChangesTracker
  class << self
    def create(question)
      Broadcast::Question::CreateTrackerWorker.perform_in(1.seconds, question.id)
    end
  end
end
