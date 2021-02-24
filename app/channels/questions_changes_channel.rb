# frozen_string_literal: true

class QuestionsChangesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'questions_changes_channel'
  end
end
