# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :registrations

      resources :users, only: [:like] do
        put :like, on: :member
      end
      resources :courses, only: [:like] do
        put :like, on: :member
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
