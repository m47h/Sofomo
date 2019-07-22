Rails.application.routes.draw do
  post 'login', to: 'sessions#login'

  constraints(ip_or_hostname: /.*/) do
    get 'geolocations/:ip_or_hostname', to: 'geolocations#show'
    delete 'geolocations/:ip_or_hostname', to: 'geolocations#destroy'
  end
  resources :geolocations, only: [:create]
end
