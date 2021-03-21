# frozen_string_literal: true

module OmniauthMacros
  def mock_auth_github_hash
    OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '1235456789',
      'info' => {
        'nickname' => 'mock_user',
        'email' => 'mockemail@users.com',
        'urls' => {
          'GitHub' => 'http://github.com'
        }
      }
    }
  end

  def mock_auth_vkontakte_hash
    OmniAuth.config.mock_auth[:vkontakte] = {
      'provider' => 'vkontakte',
      'uid' => '987654321',
      'info' => {
        'first_name' => 'mock_user_first_name',
        'last_name' => 'mock_user_last_name',
        'email' => 'mockemail@users.com',
        'urls' => {
          'Vkontakte' => 'http://vk.com'
        }
      }
    }
  end
end
