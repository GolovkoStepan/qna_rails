# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               registrations: 'registrations',
               omniauth_callbacks: 'omniauth_callbacks'
             }

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

  # Phone number confirmation
  get 'users/send_otp', to: 'phone_confirmation#send_otp', as: 'phone_confirmation_send_otp'
  post 'users/check_otp', to: 'phone_confirmation#check_otp', as: 'phone_confirmation_check_otp'

  # Email confirmation
  get 'users/send_confirmation_email', to: 'email_confirmation#send_email', as: 'email_confirmation_send_email'
  get 'users/check_token', to: 'email_confirmation#check_token', as: 'email_confirmation_check_token'
end
