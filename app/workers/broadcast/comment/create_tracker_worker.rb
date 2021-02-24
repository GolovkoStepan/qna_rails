# frozen_string_literal: true

class Broadcast::Comment::CreateTrackerWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'broadcast'
  sidekiq_options retry: false

  CHANNEL_PREFIX = 'comments_changes_channel'

  def perform(comment_id)
    comment = Comment.find(comment_id)

    # Notify anonymous users
    if redis.pubsub('channels', "#{CHANNEL_PREFIX}:anonymous").any?
      html = ApplicationController.render(partial: 'comments/comment',
                                          locals: { comment: comment, current_user: nil })
      ActionCable.server.broadcast("#{CHANNEL_PREFIX}:anonymous",
                                   { action: 'create', template: html, selector: build_selector(comment) })
    end

    # Notify authorized users
    subscribers = redis.pubsub('channels', "#{CHANNEL_PREFIX}:*")
    subscribers.reject! { |s| %W[#{CHANNEL_PREFIX}:anonymous #{CHANNEL_PREFIX}:#{comment.user_id}].include?(s) }

    subscribers.each do |subscriber|
      user = User.find_by(id: subscriber.split(':').last)
      next unless user

      html = ApplicationController.render(partial: 'comments/comment',
                                          locals: { comment: comment, current_user: nil })
      ActionCable.server.broadcast("#{CHANNEL_PREFIX}:#{user.id}",
                                   { action: 'create', template: html, selector: build_selector(comment) })
    end
  end

  private

  def build_selector(comment)
    commentable = comment.commentable
    "##{commentable.class.to_s.downcase}-#{commentable.id}-comments-block"
  end

  def redis
    @redis ||= Redis.new
  end
end
