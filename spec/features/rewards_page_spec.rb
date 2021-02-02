# frozen_string_literal: true

require 'rails_helper'

feature 'User can see their rewards' do
  given(:question) { create(:question, :with_reward) }
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User see their rewards if any' do
    question.reward.update(user_id: user.id)

    visit rewards_path

    expect(page).to have_content question.reward.name
    expect(page).to have_css("img[src*='#{question.reward.image.filename}']")
  end

  scenario 'User sees a message if there are no rewards' do
    visit rewards_path

    expect(page).to have_content "You don't have any rewards yet..."
  end
end
