Rails.application.routes.draw do
  root 'static#index'
  get  'dashboard', to: 'profiles#dashboard'
  get  'dashboard/brands', to: 'profiles#brands'
  get  'dashboard/brands/owner', to: 'profiles#brands_owner'
  get  'dashboard/brands/head', to: 'profiles#brands_head'
  post 'profiles/edit', to: 'profiles#update'
  resources :gigs
  resources :brands
end
