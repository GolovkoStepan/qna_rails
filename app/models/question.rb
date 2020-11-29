# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers

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
#
