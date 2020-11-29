# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "some_body #{n}" }
    question { nil }

    trait :invalid do
      body { nil }
    end

    trait :with_question do
      question { create :question }
    end
  end
end

# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
