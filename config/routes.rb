Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vn/ do
    root "static_pages#home"

    get "static_pages/home"
    get "/help", to: "static_pages#help", as: "help"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users do
      resources :following, only: :index, as: "followings"
      resources :followers, only: :index, as: "followers"
    end

    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end
end
