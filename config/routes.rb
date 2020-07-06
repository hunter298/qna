Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: [:votable] do
      member do
        post :best
        delete :delete_file_attached
      end
    end

    member do
      delete :delete_file_attached
    end

  end

  resources :badges, only: %i[index]
end
