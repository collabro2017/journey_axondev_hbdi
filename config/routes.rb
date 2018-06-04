Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'
  # get "*path" => "home#index"

  namespace :api do
    namespace :v1 do
      resources :activities
    end
  end
end
