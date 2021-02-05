# frozen_string_literal: true

shared_examples 'opportunity_to_vote' do
  describe 'POST #vote_plus' do
    context 'User can vote for other users resources' do
      before { login(user) }

      it do
        expect { post :vote_plus, params: { id: resource }, format: :json }
          .to change(Vote, :count).by 1
      end
    end

    context 'User cannot vote for their resource' do
      before { login(author) }

      it do
        post :vote_plus, params: { id: resource }, format: :json
        expect(JSON.parse(response.body)['status']).to eq('notAllowed')
      end
    end

    context 'Unauthorized user cannot vote' do
      it do
        post :vote_plus, params: { id: resource }, format: :json
        expect(JSON.parse(response.body)['status']).to eq('notAuthorized')
      end
    end
  end

  describe 'POST #vote_minus' do
    context 'User can vote for other users resources' do
      before { login(user) }

      it do
        expect { post :vote_minus, params: { id: resource }, format: :json }
          .to change(Vote, :count).by 1
      end
    end

    context 'User cannot vote for their resource' do
      before { login(author) }

      it do
        post :vote_minus, params: { id: resource }, format: :json
        expect(JSON.parse(response.body)['status']).to eq('notAllowed')
      end
    end

    context 'Unauthorized user cannot vote' do
      it do
        post :vote_minus, params: { id: resource }, format: :json
        expect(JSON.parse(response.body)['status']).to eq('notAuthorized')
      end
    end
  end
end
