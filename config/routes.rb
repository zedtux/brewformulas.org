require "sidekiq/web"
require "sidetiq/web"

BrewformulasOrg::Application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :imports, only: :index

  resources :formulas, only: [:index, :show], path: "" do
    member do
      get "refresh_description"
    end
  end

  root "formulas#index"
end
