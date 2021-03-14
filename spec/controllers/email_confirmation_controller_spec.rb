# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailConfirmationController, type: :controller do
  include ActiveJob::TestHelper

  let(:email) { "test#{rand(9)}@test.com" }
  let(:user)  { create :user, email: email }
  let(:token) { SecureRandom.alphanumeric(50) }

  before { login(user) }

  describe '#send_email' do
    subject { get :send_email, xhr: true }

    context 'when everything is ok' do
      before do
        expect_any_instance_of(Services::EmailConfirmation::Client)
          .to receive(:create_token).and_return(token)
        allow(EmailConfirmationMailer)
          .to receive(:send_confirmation).with(email, token).and_call_original
      end

      it 'should sent confirmation email' do
        expect { perform_enqueued_jobs { subject } }
          .to change(ActionMailer::Base.deliveries, :count).from(0).to(1)
      end
    end

    context 'when email is already confirmed' do
      before { user.update(email_confirmed: true) }

      it 'should redirect to user profile' do
        expect(subject).to redirect_to(edit_user_registration_path)
      end
    end

    context 'when too many request' do
      before do
        expect_any_instance_of(Services::EmailConfirmation::Client)
          .to receive(:create_token).and_raise(Services::EmailConfirmation::Errors::TooManyPerHour)
        subject
      end

      it 'should set result to false' do
        expect(assigns(:result)).to be_falsey
      end
    end
  end

  describe '#check_token' do
    subject { get :check_token, params: { token: token } }

    context 'when everything is ok' do
      before do
        expect_any_instance_of(Services::EmailConfirmation::Client)
          .to receive(:token_equal?).and_return(true)
        subject
      end

      it 'should set result to true' do
        expect(assigns(:result)).to be_truthy
        expect(user.reload.email_confirmed).to be_truthy
      end
    end

    context 'when token is wrong' do
      before do
        expect_any_instance_of(Services::EmailConfirmation::Client)
          .to receive(:token_equal?).and_return(false)
        subject
      end

      it 'should set result to false' do
        expect(assigns(:result)).to be_falsey
        expect(user.reload.email_confirmed).to be_falsey
      end
    end

    context 'when code is expired' do
      before do
        expect_any_instance_of(Services::EmailConfirmation::Client)
          .to receive(:token_equal?).and_raise(Services::EmailConfirmation::Errors::TokenExpired)
        subject
      end

      it 'should set result to false' do
        expect(assigns(:result)).to be_falsey
        expect(user.reload.email_confirmed).to be_falsey
      end
    end
  end
end
