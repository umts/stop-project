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

  resources :bus_stops, except: :show do
    collection do
      post :autocomplete
      get  :by_sequence
      get  :by_status
      get  :field_guide
      post :id_search
      get  :manage
      post :name_search
      get  :outdated
    end
  end
end
