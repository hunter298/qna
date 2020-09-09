Rails.application.routes.draw do
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
  end

  resources :badges, only: %i[index]
  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: %i[destroy]
  end

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: %i[index show create destroy edit update] do
        resources :answers, only: %i[index show create destroy edit update], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
