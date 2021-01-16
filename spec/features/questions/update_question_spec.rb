# frozen_string_literal: true

require 'rails_helper'

feature 'User can update his question' do
  given!(:user_author) { create(:user) }
  given!(:other_user)  { create(:user) }
  given!(:question)    { create(:question, user: user_author) }

  scenario 'Unauthenticated can not update question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit Question'
  end

  describe 'Authenticated other user' do
    background do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario "tries to edit other user's question" do
      expect(page).to_not have_link 'Edit Question'
    end
  end

  describe 'Authenticated question author', js: true do
    scenario 'can updates his question' do
      sign_in(user_author)
      visit question_path(question)

      click_on 'Edit Question'

      fill_in id: 'edit-question-title-input', with: 'new question title'
      fill_in id: 'edit-question-body-input', with: 'new question body'

      find('#question_files', visible: false)
        .attach_file(%W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb])

      click_on 'Save your changes'

      within '#question-title' do
        expect(page).to_not have_content question.title
        expect(page).to have_content 'new question title'
      end

      within '#question-body' do
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new question body'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      question.reload
      expect(question.title).to eq('new question title')
      expect(question.body).to eq('new question body')
    end

    scenario 'can delete attached files' do
      question.files.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"))

      sign_in(user_author)

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'

      within "#attachment-#{question.files.first.id}" do
        expect(page).to have_selector(class: 'delete-file-link')

        click_on(class: 'delete-file-link')
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(question.reload.files.count).to eq(0)
    end

    scenario 'updates his question with errors' do
      sign_in(user_author)

      visit question_path(question)

      click_on 'Edit Question'

      fill_in id: 'edit-question-title-input', with: 'n'
      fill_in id: 'edit-question-body-input', with: 'n'

      expect(page).to_not have_button('Save your changes')
    end
  end
end
