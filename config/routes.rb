Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        post :best
        delete :delete_file_attached
      end
    end
    delete :delete_file_attached, on: :member
  end

  resources :badges, only: %i[index]
end
