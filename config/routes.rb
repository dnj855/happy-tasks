Rails.application.routes.draw do
  root "pages#home"
  get 'family_tasks/index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :families, only: [:new, :create] do
    member do
      get 'dashboard', to: 'dashboard#view', as: :child_dashboard
      get 'add-children', to: "families#new_children"
      post 'add-children', to: "families#create_children", as: :create_children
      get 'barkley-tutorial', to: "families#barkley_tutorial"
    end
  end

  resources :tasks, only: [:new, :create, :edit, :update, :destroy, :index] do
    member do
      patch 'validate', to: 'tasks#validate'
      patch 'declare-done', to: 'tasks#declare_done'
    end
  end

  resources :family_tasks, only: [:index]

  resources :awards, only: [:index, :new, :create, :edit, :update, :destroy]

  get 'dashboard', to: 'dashboard#index', as: :family_dashboard
  get 'dashboard/children', to: 'children#new', as: :new_child
  post 'dashboard/children', to: 'children#create', as: :create_child

end
