# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: %i[index show new create edit update destroy] do
    resources :answers, shallow: true, only: %i[create edit update destroy] do
      post :mark_as_accepted, on: :member
    end
  end

  resources :attachments, only: %i[destroy]
  resources :rewards, only: %i[index]
end
