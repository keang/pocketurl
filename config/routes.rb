Rails.application.routes.draw do
  resources :short_urls, only: [:create, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'short_urls#new'

  get '/:short_path', to: 'visits#new'
end
