Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    resources :games, only: [:index, :show, :new, :create]
    root to: 'games#index'
end
