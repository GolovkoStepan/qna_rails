# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthProvider, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
  end
end

# == Schema Information
#
# Table name: oauth_providers
#
#  id         :bigint           not null, primary key
#  provider   :string           not null
#  uid        :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_oauth_providers_on_uid_and_provider  (uid,provider) UNIQUE
#  index_oauth_providers_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
