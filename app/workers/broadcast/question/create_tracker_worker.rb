# frozen_string_literal: true

class Broadcast::Question::CreateTrackerWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'broadcast'
  sidekiq_options retry: false

  def perform(question_id)
    question = Question.find(question_id)
    html = ApplicationController.render(partial: 'questions/question', locals: { question: question })
    ActionCable.server.broadcast('questions_changes_channel', { action: 'create', template: html })
  end
end
