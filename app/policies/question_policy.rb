# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user&.admin? || user&.confirmed?
  end

  def create?
    new?
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
end
