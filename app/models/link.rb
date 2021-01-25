# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: {
    with: URI::DEFAULT_PARSER.make_regexp,
    message: 'Wrong URl format. For example: https://google.com'
  }

  def gist?
    url.include? 'gist.github.com'
  end

  def gist_id
    gist? ? url.split('/').last : nil
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
