require 'sidekiq/web'

BrewformulasOrg::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
end
