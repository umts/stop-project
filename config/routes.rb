Rails.application.routes.draw do
  devise_for :users
  root 'bus_stops#index'
  resources :bus_stops, except: :show
  scope :admin do
    resources :users
  end
end
