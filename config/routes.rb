require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :documentation, only: :index

  get 'sitemap.xml' => 'home#sitemap', format: :xml, as: :sitemap
  get 'robots.:format' => 'home#robots', format: :text, as: :robots

  resources :formulas, only: [:index, :show], path: '' do
    member do
      post :refresh
    end

    collection do
      get :search
    end

    resources :dependents, only: [:index]
  end

  namespace :formulas do
    resources :news, only: :index
    resources :trendings, only: :index
  end

  root to: 'formulas#index'
end
