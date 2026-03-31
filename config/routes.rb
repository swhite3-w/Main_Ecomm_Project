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
  get "contact", to: "store#contact"

  get "cart", to: "store#cart", as: :cart
  post "cart/add/:id", to: "store#add_to_cart", as: :add_to_cart
  patch "cart/update/:id", to: "store#update_cart", as: :update_cart
  delete "cart/remove/:id", to: "store#remove_from_cart", as: :remove_from_cart
end