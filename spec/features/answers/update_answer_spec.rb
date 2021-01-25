# frozen_string_literal: true

require 'rails_helper'

feature 'Authorized user can update his answer' do
  given!(:other_user) { create :user }
  given!(:question)   { create :question }
  given!(:answer)     { create :answer, question: question }

  describe 'Authorized answer owner', js: true do
    scenario 'can update his answer' do
      sign_in(answer.user)

      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Edit Answer'

      fill_in id: 'edit-answer-form-input', with: 'new answer text'

      within '#edit-answer-form-modal' do
        find('#answer_files', visible: false)
          .attach_file(%W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb])
      end

      click_on 'Save your changes'

      expect(page).to have_content('new answer text')
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      expect(answer.reload.body).to eq('new answer text')
      expect(answer.files.count).to eq(2)
    end

    scenario 'can delete attached files' do
      answer.files.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"))

      sign_in(answer.user)

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'

      within "#attachment-#{answer.files.first.id}" do
        expect(page).to have_selector(class: 'delete-file-link')

        click_on(class: 'delete-file-link')
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(answer.reload.files.count).to eq(0)
    end

    scenario 'can attached links' do
      answer.links << build(:link)

      sign_in(answer.user)

      visit question_path(question)

      expect(page).to have_link answer.links.first.name

      within id: "answer-#{answer.id}" do
        click_on 'Edit Answer'
      end

      within id: 'edit-answer-modal-form-container' do
        click_on 'Add links'

        within '.links' do
          click_on 'Add link'
        end

        within all('.nested-fields')[1] do
          fill_in 'Name', with: 'Google'
          fill_in 'Url', with: 'https://google.com'
        end

        click_on 'Save your changes'
      end

      expect(page).to have_link answer.reload.links.last.name
      expect(answer.links.count).to eq(2)
    end

    scenario 'can not update someone else answer' do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit Answer'
    end
  end

  describe 'Unauthorized user', js: true do
    scenario 'trying to delete answer' do
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit Answer'
    end
  end
end
