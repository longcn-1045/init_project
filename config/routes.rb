Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vn/ do
    root "static_pages#home"

    get "static_pages/home"
    get "/help", to: "static_pages#help", as: "help"

    get "/signup", to: "users#new"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users, only: %i(new create show)
  end
end
