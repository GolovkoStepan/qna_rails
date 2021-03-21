# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[github vkontakte]

  def github
    @user = Services::Omniauth::Github.new(request.env['omniauth.auth']).find_or_create_user
    sign_in_and_redirect(@user, event: :authentication)
    set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
  end

  def vkontakte
    @user = Services::Omniauth::Vkontakte.new(request.env['omniauth.auth']).find_or_create_user
    sign_in_and_redirect(@user, event: :authentication)
    set_flash_message(:notice, :success, kind: 'VKontakte') if is_navigational_format?
  end
end
