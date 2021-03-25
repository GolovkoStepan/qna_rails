# frozen_string_literal: true

class Services::ResourceChangesManager::CommentChangesTracker
  class << self
    def create(comment)
      Broadcast::Comment::CreateTrackerWorker.perform_in(1.second, comment.id)
    end
  end
end
