# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question' do
  given(:user) { create(:user, :confirmed) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Create question'
    end

    scenario 'creates a question' do
      fill_in 'Title', with: 'Some question title'
      fill_in 'Body', with: 'Some question body'
      click_on 'Create Question'

      expect(page).to have_content 'Some question title'
      expect(page).to have_content 'Some question body'
    end

    scenario 'creates a question with errors' do
      click_on 'Create Question'

      expect(page).to have_content "can't be blank"
    end

    scenario 'creates a question with attached files' do
      fill_in 'Title', with: 'Some question title'
      fill_in 'Body', with: 'Some question body'

      find('#question_files', visible: false)
        .attach_file(%W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb])

      click_on 'Create Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates a question with attached links', js: true do
      fill_in 'Title', with: 'Some question title'
      fill_in 'Body', with: 'Some question body'

      click_on 'Add links'

      within '.links' do
        click_on 'Add link'
      end

      within '.nested-fields' do
        fill_in 'Name', with: 'Google'
        fill_in 'Url', with: 'https://google.com'
      end

      click_on 'Create Question'

      expect(page).to have_link 'Google', href: 'https://google.com'
    end

    scenario 'creates a question with reward', js: true do
      fill_in 'Title', with: 'Some question title'
      fill_in 'Body', with: 'Some question body'

      click_on 'Add reward'

      within id: 'reward' do
        fill_in 'Name', with: 'Thanks for your answer!'
        find('#question_reward_attributes_image', visible: false)
          .attach_file("#{Rails.root}/spec/fixtures/images/blue-circle-200.png")
      end

      click_on 'Create Question'

      question = Question.last
      expect(question.reward).to be_instance_of(Reward)
      expect(question.reward.image).to be_present
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to_not have_link 'Create question'
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Create question'

        fill_in 'Title', with: 'Some question title'
        fill_in 'Body', with: 'Some question body'
        click_on 'Create Question'

        expect(page).to have_content 'Some question title'
        expect(page).to have_content 'Some question body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_link 'Some question title'
      end
    end
  end
end
