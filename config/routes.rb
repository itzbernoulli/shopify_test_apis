Rails.application.routes.draw do
  root to: 'users#index'
  resources :users , :except => [:update]
  match 'auth/shopify/callback', to:  'users#callback', via: :get
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
