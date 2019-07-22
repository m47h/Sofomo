Rails.application.routes.draw do
  constraints(ip_or_hostname: /.*/) do
    get 'geolocations/:ip_or_hostname', to: 'geolocations#show'
    delete 'geolocations/:ip_or_hostname', to: 'geolocations#destroy'
  end
  resources :geolocations, only: [:create]
end
