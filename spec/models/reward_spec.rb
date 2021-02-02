# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:image) }
  end

  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:question) }
    it { expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One) }
  end
end

# == Schema Information
#
# Table name: rewards
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#  user_id     :bigint
#
# Indexes
#
#  index_rewards_on_question_id  (question_id)
#  index_rewards_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
