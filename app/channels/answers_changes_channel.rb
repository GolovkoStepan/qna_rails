# frozen_string_literal: true

class AnswersChangesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_changes_channel:#{current_user.present? ? current_user.id : 'anonymous'}"
  end
end
