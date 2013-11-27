require "sidekiq/web"
require "sidetiq/web"

BrewformulasOrg::Application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :formulas, path: ""

  root "formulas#index"
end
