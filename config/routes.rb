Rails.application.routes.draw do
  get 'quotes/:tag', to: 'quotes#show'
  resources :comments
  resources :posts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
