Rails.application.routes.draw do
  root 'static_pages#top'
  get '/sighup', to: 'users#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
