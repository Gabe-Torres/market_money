# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        get 'vendors', on: :member
        get 'nearest_atms', on: :member
        collection do
          get 'search'
        end
      end
      resources :vendors, only: [:show, :create, :update,  :destroy]
      resources :market_vendors, only: [:create]
      resource :market_vendors, only: [:destroy]
    end
  end
end
