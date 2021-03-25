# frozen_string_literal: true

class Services::ResourceChangesManager::AnswerChangesTracker
  class << self
    def create(answer)
      Broadcast::Answer::CreateTrackerWorker.perform_in(1.second, answer.id)
    end
  end
end
