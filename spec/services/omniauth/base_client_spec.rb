# frozen_string_literal: true

require 'rails_helper'

describe Services::Omniauth::BaseClient do
  let(:provider)   { 'some_provider_name' }
  let(:uid)        { rand(999_999_999) }
  let(:nickname)   { 'some_user_name' }
  let(:first_name) { 'some_first_name' }
  let(:last_name)  { 'some_last_name' }
  let(:email)      { 'test@testemails.com' }

  let(:auth_params) do
    {
      provider: provider,
      uid: uid,
      nickname: nickname,
      first_name: first_name,
      last_name: last_name,
      email: email
    }
  end

  before do
    expect_any_instance_of(described_class)
      .to receive(:parse_auth_params).and_return(auth_params)
  end

  subject { described_class.new(auth_params).find_or_create_user }

  context 'when provider exists' do
    let!(:user)           { create(:user, email: email) }
    let!(:oauth_provider) { create(:oauth_provider, user: user, uid: uid, provider: provider) }

    it 'should return user' do
      is_expected.to eq(user)
      expect(User.count).to eq(1)
      expect(OauthProvider.count).to eq(1)
    end
  end

  context 'when provider not found, user exists' do
    context 'when email is confirmed' do
      let!(:user) { create(:user, email: email) }

      before { user.update(email_confirmed: true) }

      it 'should creates provider and return user' do
        expect(OauthProvider.count).to eq(0)

        is_expected.to eq(user)
        expect(User.count).to eq(1)
        expect(OauthProvider.count).to eq(1)
      end
    end

    context 'when email is not confirmed' do
      let!(:user) { create(:user, email: email, email_confirmed: false) }

      it 'should creates provider and create new user' do
        is_expected.to_not eq(user)
        expect(User.count).to eq(2)
        expect(OauthProvider.count).to eq(1)
      end
    end
  end

  context 'when user is not exists' do
    it 'should creates provider and create user' do
      expect(User.count).to eq(0)

      is_expected.to be_an_instance_of(User)
      expect(User.count).to eq(1)
      expect(OauthProvider.count).to eq(1)
    end
  end

  context 'when provider dont send email' do
    let(:email) { nil }

    it 'should creates provider and create unconfirmed user' do
      expect(User.count).to eq(0)

      is_expected.to be_an_instance_of(User)
      expect(User.count).to eq(1)
      expect(OauthProvider.count).to eq(1)
      expect(User.last.confirmed?).to be_falsey
    end
  end
end
