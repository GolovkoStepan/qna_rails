# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voteable do
    member do
      post :vote_plus
      post :vote_minus
    end
  end

  resources :questions, concerns: %i[voteable], only: %i[index show new create edit update destroy] do
    resources :answers, concerns: %i[voteable], shallow: true, only: %i[create edit update destroy] do
      post :mark_as_accepted, on: :member
    end
  end

  resources :attachments, only: %i[destroy]
  resources :rewards, only: %i[index]
end
