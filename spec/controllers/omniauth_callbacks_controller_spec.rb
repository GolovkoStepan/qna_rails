# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  context '#github' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth']  = mock_auth_github_hash

      expect(Services::Omniauth::Github)
        .to receive(:new).with(request.env['omniauth.auth']).and_call_original

      expect_any_instance_of(Services::Omniauth::Github)
        .to receive(:find_or_create_user).and_call_original
    end

    subject { post :github }

    it 'should create or find user, login and redirect' do
      is_expected.to redirect_to(root_path)
    end
  end

  context '#vkontakte' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth']  = mock_auth_vkontakte_hash

      expect(Services::Omniauth::Vkontakte)
        .to receive(:new).with(request.env['omniauth.auth']).and_call_original

      expect_any_instance_of(Services::Omniauth::Vkontakte)
        .to receive(:find_or_create_user).and_call_original
    end

    subject { post :vkontakte }

    it 'should create or find user, login and redirect' do
      is_expected.to redirect_to(root_path)
    end
  end
end
