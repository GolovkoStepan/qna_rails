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

    scenario 'creates a question with attached files' do
      fill_in id: 'create_answer_input', with: 'answer text'

      within '.new-answer' do
        find('#answer_files', visible: false)
          .attach_file(%W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb])
      end

      click_on 'Post your answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates a answer with attached links', js: true do
      fill_in id: 'create_answer_input', with: 'answer text'

      click_on 'Add links'

      within '.links' do
        click_on 'Add link'
      end

      within '.nested-fields' do
        fill_in 'Name', with: 'Google'
        fill_in 'Url', with: 'https://google.com'
      end

      click_on 'Post your answer'

      expect(page).to have_link 'Google', href: 'https://google.com'
    end

    scenario 'can not create answer with wrong length' do
      fill_in id: 'create_answer_input', with: ''

      click_on 'Post your answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to question answer', js: true do
    visit question_path(question)
    expect(page).to_not have_selector('#create_answer_input')
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in id: 'create_answer_input', with: 'answer text'
        click_on 'Post your answer'

        expect(page).to have_content 'answer text'
        expect(question.answers.count).to eq(1)
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer text'
      end
    end
  end
end
