# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for a question' do
  given!(:user_author) { create(:user) }
  given!(:other_user)  { create(:user) }
  given!(:question)    { create(:question, user: user_author) }
  given!(:answer)      { create(:answer, question: question, user: user_author) }

  scenario 'Unauthenticated can not vote for answer', js: true do
    visit question_path(question)

    accept_alert do
      within id: "answer-#{answer.id}-vote-block" do
        find('.vote-plus').click
      end
    end

    expect(answer.reload.current_rating).to eq(0)
  end

  describe 'Authenticated other user' do
    background do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'tries to vote for a answer', js: true do
      within id: "answer-#{answer.id}-vote-block" do
        find('.vote-plus').click
      end

      within id: "answer-#{answer.id}-vote-block" do
        within class: 'current-rating' do
          expect(page).to have_content('1')
        end
      end

      expect(answer.reload.current_rating).to eq(1)
    end
  end

  describe 'Authenticated answer author' do
    background do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'tries to vote for his answer', js: true do
      accept_alert do
        within id: "answer-#{answer.id}-vote-block" do
          find('.vote-plus').click
        end
      end

      within id: "answer-#{answer.id}-vote-block" do
        within class: 'current-rating' do
          expect(page).to have_content('0')
        end
      end

      expect(answer.reload.current_rating).to eq(0)
    end
  end
end
