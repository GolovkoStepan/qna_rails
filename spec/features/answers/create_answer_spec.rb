# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer' do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'trying to create answer' do
      fill_in id: 'create_answer_input', with: 'answer text'
      click_on 'Post your answer'

      expect(page).to have_content 'answer text'
      expect(question.answers.count).to eq(1)
    end

    scenario 'can not create answer with wrong length' do
      fill_in id: 'create_answer_input', with: 'a'
      expect(page).to_not have_button('Post your answer')
    end
  end

  scenario 'Unauthenticated user tries to question answer', js: true do
    visit question_path(question)
    expect(page).to_not have_selector('#create_answer_input')
  end
end
