# frozen_string_literal: true

require 'rails_helper'

feature 'Authorized user can delete his answer' do
  given!(:other_user) { create :user }
  given!(:question)   { create :question }
  given!(:answer)     { create :answer, question: question }

  describe 'Authorized user', js: true do
    scenario 'can delete his answer' do
      sign_in(answer.user)

      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Delete Answer'

      expect(page).not_to have_content(answer.body)
      expect(question.answers.count).to eq(0)
    end

    scenario 'can not delete someone else question' do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Delete Question'
    end
  end

  describe 'Unauthorized user', js: true do
    scenario 'trying to delete question' do
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Delete Answer'
    end
  end
end
