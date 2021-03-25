# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:nickname) { |n| SecureRandom.alphanumeric(n + 10) }
    sequence(:email) { |n| "user_#{n}@qwerty.com" }
    password { '11223344' }
    password_confirmation { '11223344' }

    trait :confirmed do
      email_confirmed { true }
      phone_confirmed { true }
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
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
