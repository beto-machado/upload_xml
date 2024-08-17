require "sidekiq/web"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'password'
end

Rails.application.routes.draw do
  root "documents#new"
  
  resources :documents, only: [:new, :create]
  resources :reports, only: [:show]

  devise_for :users
  
  mount Sidekiq::Web, at: "sidekiq"
end
