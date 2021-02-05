# frozen_string_literal: true

shared_examples 'has_votes' do
  let(:voting_user) { create :user }

  before { 5.times { voteable.votes.create(attributes_for(:vote, user: (create :user))) } }

  it '#current_rating' do
    expect(voteable.current_rating).to eq(5)
  end

  it '#vote' do
    voteable.vote(voting_user, 1)
    expect(voteable.current_rating).to eq(6)

    voteable.vote(voting_user, 1)
    expect(voteable.current_rating).to eq(6)

    voteable.vote(voting_user, -1)
    expect(voteable.current_rating).to eq(4)
  end
end
