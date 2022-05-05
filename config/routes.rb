Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :application, only: [:index, :show, :update, :create] do
        resources :chat, only: [:index, :show, :create] do
          get :search
          resources :message, only: [:index, :show, :create]
        end
      end
    end
  end
end
