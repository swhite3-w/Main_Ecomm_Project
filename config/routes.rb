Rails.application.routes.draw do
  get "store/index"
  get "store/show"
  get "store/category"
  get "store/about"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "store#index"

  get "products/:id", to: "store#show", as: :product
  get "categories/:id", to: "store#category", as: :category
  get "about", to: "store#about"
end