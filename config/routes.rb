Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
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
        delete :delete_file_attached
      end
    end

    resources :comments, shallow: true, only: %i[create]

    member do
      delete :delete_file_attached
    end

  end

  resources :badges, only: %i[index]

  mount ActionCable.server => '/cable'
end
