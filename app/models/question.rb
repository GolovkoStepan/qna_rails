# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :title, :body, presence: true
end

# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
