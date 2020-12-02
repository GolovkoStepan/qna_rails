# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the question and answers to it' do
  given!(:question) { create(:question, :with_answers) }

  scenario 'User can view the question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
