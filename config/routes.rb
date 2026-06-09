Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login',    to: 'auth#login'
      post 'auth/cadastro', to: 'auth#cadastro'
      resources :agendamentos, only: [:index, :create, :update, :destroy] do
        collection do
          get 'status/:status', to: 'agendamentos#by_status'
        end
      end
      resources :horarios,     only: [:index, :create, :destroy]
      resources :servicos,     only: [:index, :create, :update, :destroy]
    end
  end
end
