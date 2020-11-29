# frozen_string_literal: true

Rails.application.routes.draw do
  resources :questions, only: %i[show new create] do
    resources :answers, only: %i[show new create]
  end
end
