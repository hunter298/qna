require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  post '/oauth_email_confirmation', to: 'users#oauth_email_confirmation'

  get '/search', to: 'searches#search'

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
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create destroy edit update] do
        resources :answers, only: %i[index show create destroy edit update], shallow: true
      end
    end
  end

  resources :users, only: %i[show]

  mount ActionCable.server => '/cable'
end
