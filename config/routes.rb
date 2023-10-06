# frozen_string_literal: true

Rails.application.routes.draw do
  root 'bus_stops#index'

  devise_for :users
  as :user do
    get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
    put 'users', to: 'devise/registrations#update', as: :user_registration
  end
  scope :admin do
    resources :users, except: :show
  end

  post '/dev_login', to: 'dev_login#create', as: 'dev_login' if Rails.env.development?

  resources :bus_stops, except: :show do
    collection do
      get :autocomplete
      get  :by_sequence
      get  :by_status
      get  :field_guide
      get  :manage
      get  :outdated
      post :search
    end
  end
end
