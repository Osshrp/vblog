Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'posts#index'

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
      resources :posts do
        resources :comments, shallow: true
      end
    end
  end
end
