# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    user { create :user }
    sequence(:title) { |n| "some_question_title #{n}" }
    sequence(:body) { |n| "some_question_body #{n}" }

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :with_answers do
      answers { build_list :answer, 5 }
    end
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
