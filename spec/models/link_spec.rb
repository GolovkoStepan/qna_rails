# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
  end

  context 'when add gist link' do
    let(:question) { create :question }
    let(:gist_id) { '7a9f2bc21284ff3a29ef9a9d55f7d5bf' }
    let(:link) do
      create :link, url: "https://gist.github.com/GolovkoStepan/#{gist_id}", linkable: question
    end

    it '#gist? returns true' do
      expect(link.gist?).to be_truthy
    end

    it '#gist_id returns id from gist link' do
      expect(link.gist_id).to eq(gist_id)
    end
  end
end

# == Schema Information
#
# Table name: links
#
#  id            :bigint           not null, primary key
#  linkable_type :string
#  name          :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  linkable_id   :bigint
#
# Indexes
#
#  index_links_on_linkable_type_and_linkable_id  (linkable_type,linkable_id)
#
