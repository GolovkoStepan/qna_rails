# frozen_string_literal: true

require 'rails_helper'

describe QuestionPolicy do
  subject { described_class }

  permissions :new?, :create? do
    it 'denied if user is not confirmed' do
      expect(subject).not_to permit(User.new, Question.new)
    end

    it 'granted if user is confirmed' do
      expect(subject).to permit(User.new(email_confirmed: true), Question.new)
    end

    it 'granted if admin' do
      expect(subject).to permit(User.new(admin: true), Question.new)
    end
  end

  permissions :edit?, :update?, :destroy? do
    it 'denied if user is confirmed and question is not created by user' do
      expect(subject).not_to permit(User.new(email_confirmed: true), Question.new)
    end

    it 'granted if user is confirmed and question is created by user' do
      user     = create :user, :confirmed
      question = create :question, user: user

      expect(subject).to permit(user, question)
    end

    it 'granted if admin' do
      expect(subject).to permit(User.new(admin: true), Question.new)
    end
  end
end
