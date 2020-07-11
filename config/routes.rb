Rails.application.routes.draw do
  resources :recipes, only: [:index, :show]
  root to: 'recipes#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
