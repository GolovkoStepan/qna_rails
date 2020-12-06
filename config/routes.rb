# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: %i[index show new create destroy] do
    resources :answers, shallow: true, only: %i[create destroy]
  end
end
