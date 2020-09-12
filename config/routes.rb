require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: {omniauth_callbacks: 'oauth_callbacks'}
  post '/oauth_email_confirmation', to: 'users#oauth_email_confirmation'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: [:votable] do
      resources :comments, shallow: true, only: %i[create]
      member do
        post :best
      end
    end

    resources :comments, shallow: true, only: %i[create]

    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :badges, only: %i[index]
  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: %i[destroy]
  end

  namespace :api do
    namespace :v1 do
<<<<<<< HEAD
      resources :profiles, only: %i[index] do
        get :me, on: :collection
=======
      resource :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
>>>>>>> 4e82c86f711bb113aabbaa29de28b74a45ee9788
      end

      resources :questions, only: %i[index show create destroy edit update] do
        resources :answers, only: %i[index show create destroy edit update], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
