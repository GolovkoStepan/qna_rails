# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question' do
  given(:user) { create(:user) }

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
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to_not have_link 'Create question'
  end
end
