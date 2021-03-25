# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def create?
    user&.admin? || user&.confirmed?
  end

  def edit?
    user&.admin? || (user&.confirmed? && user&.created_by_me?(record))
  end

  def update?
    edit?
  end

  def destroy?
    user&.admin? || (user&.confirmed? && user&.created_by_me?(record))
  end

  def mark_as_accepted?
    user&.admin? || (user&.confirmed? && user&.created_by_me?(record.question))
  end
end
