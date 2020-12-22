# frozen_string_literal: true

require 'rails_helper'

feature 'Authorized user can update his question' do
  given!(:other_user) { create :user }
  given!(:question)   { create :question }
  given!(:answer)     { create :answer, question: question }

  describe 'Authorized answer owner', js: true do
    scenario 'can update his question' do
      sign_in(answer.user)

      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Edit Answer'

      fill_in id: 'edit-answer-form-input', with: 'new answer text'

      click_on 'Save your changes'

      expect(page).to have_content('new answer text')
      expect(answer.reload.body).to eq('new answer text')
    end

    scenario 'can not update someone else answer' do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit Answer'
    end
  end

  describe 'Unauthorized user', js: true do
    scenario 'trying to delete question' do
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit Answer'
    end
  end
end
