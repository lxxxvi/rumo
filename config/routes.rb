Rails.application.routes.draw do
  devise_for :hosts

  get 'about', to: 'home#about', as: :about
  get 'visit/:host_url_identifier', to: 'visits#new', as: :visit
  post 'visit/:host_url_identifier', to: 'visits#create'
  get :visits, to: 'visits#index'

  namespace :admin do
    resources :visits, only: %i[index update destroy], param: :token
    resource :qr_code, only: :show
    resources :downloads, only: %i[new create]
    resource :settings, only: %i[edit update]
    root to: 'home#index'
  end

  post '/', to: 'home#index'

  root to: 'home#index'
end
