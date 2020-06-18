Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy update] do
      post :best, on: :member
    end
  end
end
