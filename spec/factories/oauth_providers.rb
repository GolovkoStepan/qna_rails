# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_provider do
    sequence(:uid) { |i| rand(999_999_999) + i }
    provider { 'some_provider_name' }
    url { 'http://example.omg' }
    user { nil }
  end
end

# == Schema Information
#
# Table name: oauth_providers
#
#  id         :bigint           not null, primary key
#  provider   :string           not null
#  uid        :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_oauth_providers_on_uid_and_provider  (uid,provider) UNIQUE
#  index_oauth_providers_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
