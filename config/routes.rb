require "sidekiq/web"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'password'
end

Rails.application.routes.draw do
  root "reports#index"
  
  resources :documents, only: [:new, :create] do
    resources :reports, only: [:show]
  end

  resources :reports, only: [:index] do
    member do
      get :export_to_csv
    end
  end

  devise_for :users
  
  mount Sidekiq::Web, at: "sidekiq"
end
