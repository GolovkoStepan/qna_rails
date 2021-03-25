# frozen_string_literal: true

require 'rails_helper'

describe AnswerPolicy do
  subject { described_class }

  permissions :create? do
    it 'denied if user is not confirmed' do
      expect(subject).not_to permit(User.new, Answer.new)
    end

    it 'granted if user is confirmed' do
      expect(subject).to permit(User.new(email_confirmed: true), Answer.new)
    end

    it 'granted if admin' do
      expect(subject).to permit(User.new(admin: true), Answer.new)
    end
  end

  permissions :edit?, :update?, :destroy? do
    it 'denied if user is confirmed and answer is not created by user' do
      expect(subject).not_to permit(User.new(email_confirmed: true), Answer.new)
    end

    it 'granted if user is confirmed and answer is created by user' do
      user   = create :user, :confirmed
      answer = create :answer, user: user, question: (create :question)

      expect(subject).to permit(user, answer)
    end

    it 'granted if admin' do
      expect(subject).to permit(User.new(admin: true), Question.new)
    end
  end

  permissions :mark_as_accepted? do
    it 'granted if user is confirmed and question is created by user' do
      user   = create :user, :confirmed
      answer = create :answer, question: (create :question, user: user)

      expect(subject).to permit(user, answer)
    end

    it 'granted if admin' do
      expect(subject).to permit(User.new(admin: true), Question.new)
    end
  end
end
