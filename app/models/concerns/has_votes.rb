# frozen_string_literal: true

module HasVotes
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def current_rating
    votes.sum(:value)
  end

  def vote!(user, value)
    if (vote = votes.find_by(user: user))
      vote.update!(value: value)
    else
      votes.create!(user: user, value: value)
    end
  end

  def vote(user, value)
    vote!(user, value)
  rescue ActiveRecord::RecordInvalid
    false
  end
end
