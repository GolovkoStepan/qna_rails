# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    value { 1 }
    user { nil }
    voteable { nil }
  end
end

# == Schema Information
#
# Table name: votes
#
#  id            :bigint           not null, primary key
#  value         :integer
#  voteable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#  voteable_id   :bigint
#
# Indexes
#
#  index_votes_on_user_id   (user_id)
#  index_votes_on_voteable  (voteable_type,voteable_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
