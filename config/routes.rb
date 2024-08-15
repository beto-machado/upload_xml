require "sidekiq/web"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'password'
end

Rails.application.routes.draw do
  devise_for :users

  # root "posts#index"
  
  mount Sidekiq::Web, at: "sidekiq"
end
