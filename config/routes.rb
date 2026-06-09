Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login',    to: 'auth#login'
      post 'auth/cadastro', to: 'auth#cadastro'
      resources :agendamentos, only: [:index, :create, :update, :destroy]
      resources :horarios,     only: [:index, :create, :destroy]
      resources :servicos,     only: [:index, :create, :update, :destroy]
      get  'promocoes',              to: 'promocoes#index'
      get  'promocoes/data',         to: 'promocoes#show_by_data'
      post 'promocoes/calcular',     to: 'promocoes#calcular'
    end
  end
end
