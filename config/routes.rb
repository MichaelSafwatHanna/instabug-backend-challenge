Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :application, only: [:index, :show, :update, :create] do
    resources :chat, only: [:index, :show, :update, :create] do
      get :search
      resources :message, only: [:index, :show, :create] 
    end
  end
end
