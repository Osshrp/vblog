Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'users#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, shallow: true
      end
    end
  end

  resources :users
end
