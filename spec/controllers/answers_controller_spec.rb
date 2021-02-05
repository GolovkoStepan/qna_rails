# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user)     { create :user }
  let!(:question) { create :question, user: user }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, xhr: true, params: { question_id: question, answer: { body: 'some_body' } } }
          .to change(question.reload.answers, :count).by(1)
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, xhr: true, params: { question_id: question, answer: { body: '' } } }
          .to_not change(question.reload.answers, :count)
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #update' do
    let!(:answer) { create :answer, question: question, user: user }

    context 'owned by the current user' do
      before { login(user) }

      it 'saves a new answer in the database' do
        post :update, xhr: true, params: { id: answer.id, answer: { body: 'some_new_body' } }

        expect(answer.reload.body).to eq('some_new_body')
        expect(response).to render_template :update
      end
    end

    context 'not owned by the current user' do
      before { login(create(:user)) }

      it 'does not save the question' do
        post :update, xhr: true, params: { id: answer.id, answer: { body: 'some_new_body' } }

        expect(answer.reload.body).to_not eq('some_new_body')
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer, question: question, user: user }

    context 'owned by the current user' do
      before { login(user) }

      it 'deletes answer' do
        delete :destroy, xhr: true, params: { id: answer.id }

        expect(Answer.count).to eq(0)
        expect(response).to have_http_status(200)
      end
    end

    context 'not owned by the current user' do
      before { login(create(:user)) }

      it 'does not delete answer' do
        delete :destroy, xhr: true, params: { id: answer.id }

        expect(Answer.count).to eq(1)
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'POST #mark_as_accepted' do
    let!(:answer) { create :answer, question: question, user: user }

    context 'question owned by the current user' do
      before { login(user) }

      it 'marks answer as accepted' do
        post :mark_as_accepted, xhr: true, params: { id: answer.id }

        expect(answer.reload.accepted).to eq(true)
        expect(response).to have_http_status(200)
      end
    end

    context 'question not owned by the current user' do
      before { login(create(:user)) }

      it 'does not delete answer' do
        post :mark_as_accepted, xhr: true, params: { id: answer.id }

        expect(answer.reload.accepted).to eq(false)
        expect(response).to have_http_status(403)
      end
    end
  end

  it_behaves_like 'opportunity_to_vote' do
    let(:user)     { create :user }
    let(:author)   { create :user }
    let(:question) { create :question, user: user }
    let(:resource) { create :answer, question: question, user: author }
  end
end
