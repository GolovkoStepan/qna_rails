# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:voteable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value) }
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
