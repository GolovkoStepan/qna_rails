# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in via omniauth' do
  it 'can sign in user with Github account' do
    visit new_user_session_path

    expect(page).to have_link 'Sign in with GitHub'

    mock_auth_github_hash

    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from GitHub account.'

    expect(User.count).to eq(1)
  end

  it 'can sign in user with VK account' do
    visit new_user_session_path

    expect(page).to have_link 'Sign in with Vkontakte'

    mock_auth_vkontakte_hash

    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from VKontakte account.'

    expect(User.count).to eq(1)
  end

  it 'can handle authentication error' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials

    visit new_user_session_path

    expect(page).to have_link 'Sign in with GitHub'

    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
  end
end
