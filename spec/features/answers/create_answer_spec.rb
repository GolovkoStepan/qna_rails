# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer' do
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(question.user)

      visit question_path(question)
    end

    scenario 'question answer' do
      fill_in 'Body', with: 'answer text'
      click_on 'Create Answer'

      expect(page).to have_content 'answer text'
    end
  end

  scenario 'Unauthenticated user tries to question answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Create Answer'
  end
end
