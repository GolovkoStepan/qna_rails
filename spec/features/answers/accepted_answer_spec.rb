# frozen_string_literal: true

require 'rails_helper'

feature 'Authorized question owner can accept question' do
  given!(:other_user) { create :user }
  given!(:question)   { create :question }
  given!(:answer)     { create :answer, question: question }

  describe 'Authorized question owner', js: true do
    scenario 'can accept answer' do
      sign_in(question.user)

      visit question_path(question)

      click_on 'Mark as accepted'

      within "#answer-#{answer.id}" do
        expect(page).to have_selector('.accepted-answer-icon')
      end

      expect(answer.reload.accepted).to be_truthy
    end

    scenario 'can accept answer for questions with reward' do
      question.create_reward(attributes_for(:reward))

      sign_in(question.user)

      visit question_path(question)

      click_on 'Mark as accepted'

      within "#answer-#{answer.id}" do
        expect(page).to have_selector('.accepted-answer-icon')
      end

      expect(answer.reload.accepted).to be_truthy
      expect(answer.user.rewards.count).to eq(1)
    end

    scenario 'can not accept answer for someone else question' do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to_not have_link 'Mark as accepted'
    end
  end
end
