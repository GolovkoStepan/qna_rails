# frozen_string_literal: true

Rails.application.routes.draw do
  get 'comments/new'
  get 'comments/create'
  devise_for :users
  root to: 'questions#index'

  concern :voteable do
    member do
      post :vote_plus
      post :vote_minus
    end
  end

  concern :commentable do
    resources :comments, only: %i[new create]
  end

  resources :questions, concerns: %i[voteable commentable], only: %i[index show new create edit update destroy] do
    resources :answers, concerns: %i[voteable commentable], shallow: true, only: %i[create edit update destroy] do
      post :mark_as_accepted, on: :member
    end
  end

  resources :attachments, only: %i[destroy]
  resources :rewards, only: %i[index]
end
