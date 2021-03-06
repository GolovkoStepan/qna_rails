# frozen_string_literal: true

class Broadcast::Answer::CreateTrackerWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'broadcast'
  sidekiq_options retry: false

  CHANNEL_PREFIX = 'answers_changes_channel'

  def perform(answer_id)
    answer = Answer.find(answer_id)

    # Notify anonymous users
    if redis.pubsub('channels', "#{CHANNEL_PREFIX}:anonymous").any?
      html = ApplicationController.render(partial: 'answers/answer', locals: { answer: answer, current_user: nil })
      ActionCable.server.broadcast("#{CHANNEL_PREFIX}:anonymous", { action: 'create', template: html })
    end

    # Notify authorized users
    subscribers = redis.pubsub('channels', "#{CHANNEL_PREFIX}:*")
    subscribers.reject! { |s| %W[#{CHANNEL_PREFIX}:anonymous #{CHANNEL_PREFIX}:#{answer.user_id}].include?(s) }

    subscribers.each do |subscriber|
      user = User.find_by(id: subscriber.split(':').last)
      next unless user

      html = ApplicationController.render(partial: 'answers/answer', locals: { answer: answer, current_user: user })
      ActionCable.server.broadcast("#{CHANNEL_PREFIX}:#{user.id}", { action: 'create', template: html })
    end
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
