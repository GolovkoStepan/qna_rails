# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
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
