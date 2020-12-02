# frozen_string_literal: true

require 'rails_helper'

feature 'User can see a list of questions' do
  given!(:questions) { create_list :question, 5 }

  scenario 'User sees a list of questions' do
    visit questions_path
    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
