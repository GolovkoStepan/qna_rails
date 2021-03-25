# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "some_answer_body #{n}" }
    question { nil }
    user { create :user, :confirmed }

    trait :invalid do
      body { nil }
    end

    trait :with_question do
      question { create :question }
    end

    trait :with_files do
      files do
        [
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"),
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb")
        ]
      end
    end
  end
end

# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  accepted    :boolean          default(FALSE)
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#  index_answers_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (user_id => users.id)
#
