# frozen_string_literal: true

module OpportunityToVote
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: %i[vote_plus vote_minus]
  end

  def vote_plus
    make_vote(1)
  end

  def vote_minus
    make_vote(-1)
  end

  private

  def make_vote(value)
    return not_authorized_response unless current_user

    @voteable = controller_name.classify.constantize.find(params[:id])
    return not_allowed_response if current_user.created_by_me?(@voteable)

    @voteable.vote!(current_user, value)
    ok_response
  rescue StandardError => e
    internal_error_response(e)
  end

  def ok_response
    render json: { status: 'ok', rating: @voteable.current_rating }
  end

  def not_authorized_response
    render json: { status: 'notAuthorized', message: 'You must be logged in to vote!' }
  end

  def not_allowed_response
    render json: { status: 'notAllowed', message: 'You cannot vote for what is created by you!' }
  end

  def internal_error_response(error)
    render json: { status: 'internalError', message: error.message }
  end
end
