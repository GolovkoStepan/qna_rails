# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user)           { create :user }
  let!(:other_user)     { create :user }
  let!(:question)       { create :question, :with_files, user: user }
  let!(:other_question) { create :question, :with_files, user: other_user }

  before { login user }

  context 'Authenticated user' do
    it 'can deletes his attached file' do
      expect { delete :destroy, params: { id: question.files.first }, xhr: true }
        .to change(question.files, :count).by(-1)
    end

    it 'can not deletes not his file' do
      expect { delete :destroy, params: { id: other_question.files.first }, xhr: true }
        .to_not change(other_question.files, :count)
      expect(response.code).to eq('403')
    end
  end

  context 'When file not found' do
    it 'returns status 404' do
      delete :destroy, params: { id: rand(9_000_000) }, xhr: true
      expect(response.code).to eq('404')
    end
  end
end
