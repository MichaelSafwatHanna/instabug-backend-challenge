# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :application, only: %i[index show update create] do
        resources :chat, only: %i[index show create] do
          get :search
          resources :message, only: %i[index show create]
        end
      end
    end
  end
end
