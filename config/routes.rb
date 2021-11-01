Rails.application.routes.draw do
  get 'quotes/:tag', to: 'quotes#show'
end
