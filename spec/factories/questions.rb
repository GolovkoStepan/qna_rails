# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "some_title #{n}" }
    sequence(:body) { |n| "some_body #{n}" }
  end
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
