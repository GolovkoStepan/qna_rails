# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, :image, presence: true
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
