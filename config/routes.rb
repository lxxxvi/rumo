Rails.application.routes.draw do
  resources :attendances, only: %w[new create show], param: :token
  get 'my/attendances(/:tokens)', to: 'attendances#list', as: :my_attendances

  namespace :coaches do
    resources :attendances, only: %w[index destroy], param: :token do
      get :confirm, on: :member
    end
  end

  root to: 'home#index'
end
