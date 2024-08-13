Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      resources :products
    end
  end
  
  devise_for :users, controllers: { sessions: 'users/sessions' }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
