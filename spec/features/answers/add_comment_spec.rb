# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comment to answer' do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer)   { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to create comment for answer' do
    visit question_path(question)

    within '.answer-comments' do
      click_on 'Add Comment'
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for answer with valid attributes' do
      within '.answer-comments' do
        click_on 'Add Comment'
      end

      fill_in id: 'new-comment-form-input', with: 'some_comment_text'
      click_on 'Add your comment'

      within id: "answer-#{answer.id}-comments-block" do
        expect(page).to have_content 'some_comment_text'
      end
    end

    scenario 'creates comment for answer with invalid attributes' do
      within '.answer-comments' do
        click_on 'Add Comment'
      end

      fill_in id: 'new-comment-form-input', with: ''
      click_on 'Add your comment'

      within id: 'new-comment-form-modal' do
        expect(page).to have_content "Body can't be blank and Body is too short (minimum is 2 characters)"
      end
    end
  end

  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer-comments' do
          click_on 'Add Comment'
        end

        fill_in id: 'new-comment-form-input', with: 'some_comment_text'
        click_on 'Add your comment'

        within id: "answer-#{answer.id}-comments-block" do
          expect(page).to have_content 'some_comment_text'
        end
      end

      Capybara.using_session('guest') do
        within id: "answer-#{answer.id}-comments-block" do
          expect(page).to have_content 'some_comment_text'
        end
      end
    end
  end
end
