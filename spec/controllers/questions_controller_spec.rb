# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user)     { create :user }

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question, :with_reward) } }
          .to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question, :with_reward) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    let!(:question) { create :question, user: user }

    context 'question owned by the current user' do
      before { login(user) }

      it 'updates question' do
        post :update, xhr: true, params: { id: question.id, question: { title: 'new_title', body: 'new_body' } }

        expect(question.reload.title).to eq('new_title')
        expect(question.reload.body).to eq('new_body')
        expect(response).to render_template(:update)
      end
    end

    context 'question not owned by the current user' do
      before { login(create(:user)) }

      it 'does not update question' do
        post :update, xhr: true, params: { id: question.id, question: { title: 'new_title', body: 'new_body' } }

        expect(question.reload.title).to_not eq('new_title')
        expect(question.reload.body).to_not eq('new_body')
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create :question, user: user }

    context 'question owned by the current user' do
      before { login(user) }

      it 'delete question' do
        delete :destroy, xhr: true, params: { id: question.id }

        expect(Question.count).to eq(0)
        expect(response).to redirect_to(questions_path)
      end
    end

    context 'question not owned by the current user' do
      before { login(create(:user)) }

      it 'does not delete question' do
        delete :destroy, xhr: true, params: { id: question.id }

        expect(Question.count).to eq(1)
        expect(response).to redirect_to(question_path(question))
      end
    end
  end
end
