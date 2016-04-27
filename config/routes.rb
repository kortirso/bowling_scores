Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    resources :games, only: [:index, :show, :new, :create]
    resources :throw, only: :create
    root to: 'games#index'
    match "*path", to: "application#catch_404", via: :all
end
