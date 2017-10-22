Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'users#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :root
    end
  end

  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, shallow: true
      end
      resources :reports, only: :by_author do
        post 'by_author', on: :collection
      end
    end
  end

  resources :users, only: [:show, :update]
end
