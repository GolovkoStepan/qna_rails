# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value,
            presence: true,
            numericality: { only_integer: true, less_than_or_equal_to: 1, greater_than_or_equal_to: -1 }
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
