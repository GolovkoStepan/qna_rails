# frozen_string_literal: true

require 'rails_helper'

feature 'Authorized user can delete his question' do
  given(:other_user) { create :user }
  given!(:question) { create :question }

  describe 'Authorized question owner' do
    scenario 'question owner can delete his question' do
      sign_in(question.user)

      visit question_path(question)

      expect(page).to have_content question.title

      click_on 'Delete Question'

      expect(page).not_to have_content question.title
    end

    scenario 'other user can not delete someone else question' do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete Question'
    end
  end

  describe 'Unauthorized user' do
    scenario 'trying to delete question' do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete Question'
    end
  end
end
