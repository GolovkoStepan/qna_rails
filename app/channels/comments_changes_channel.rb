# frozen_string_literal: true

class CommentsChangesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_changes_channel:#{current_user.present? ? current_user.id : 'anonymous'}"
  end
end
