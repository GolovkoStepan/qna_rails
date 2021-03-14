# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Login', with: user.nickname
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end
