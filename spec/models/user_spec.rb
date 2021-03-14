# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:rewards) }
    it { should have_many(:votes) }
    it { should have_many(:comments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:nickname) }
    it { should validate_presence_of(:password) }
  end

  context 'when email changed' do
    let(:user) { create :user }

    before do
      user.update(email: 'test@test.com')
      user.update(email_confirmed: true)
    end

    it 'should set email_confirmed to false' do
      expect(user.email_confirmed).to be_truthy
      user.update(email: 'test-1@test.com')
      expect(user.email_confirmed).to be_falsey
    end
  end

  context 'when phone changed' do
    let(:user) { create :user }

    before do
      user.update(phone: 79_000_000_000)
      user.update(phone_confirmed: true)
    end

    it 'should set phone_confirmed to false' do
      expect(user.phone_confirmed).to be_truthy
      user.update(phone: 79_000_000_001)
      expect(user.phone_confirmed).to be_falsey
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  email_confirmed        :boolean          default(FALSE)
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  nickname               :string           default(""), not null
#  phone                  :bigint
#  phone_confirmed        :boolean          default(FALSE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
