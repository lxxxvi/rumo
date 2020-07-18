Rails.application.routes.draw do
  devise_for :hosts

  get 'visit/:host_url_identifier', to: 'visits#new', as: :visit
  post 'visit/:host_url_identifier', to: 'visits#create'
  get :visits, to: 'visits#index'

  namespace :admin do
    resources :visits, only: :index, param: :token do
      resource :confirmation, only: :create, module: :visits
      resource :rejection, only: :create, module: :visits
    end

    resource 'qr_code', only: :show
    root to: 'home#index'
  end

  post '/', to: 'home#index'

  root to: 'home#index'
end
