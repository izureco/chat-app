Rails.application.routes.draw do
  devise_for :users
  get 'messages/index'
  resources :users, only: [:edit, :update]
  resources :rooms, only: [:new, :create] do
    resources :messages, only: [:create, :index]
  end
  root to: "rooms#index"
end
