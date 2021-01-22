# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "Link name #{n}" }
    sequence(:url) { |n| "http://google.com/#{n}" }
    linkable { nil }
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
