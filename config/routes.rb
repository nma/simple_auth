Rails.application.routes.draw do
  resources :users
  match '/signup', :to => 'users#new' 

end
