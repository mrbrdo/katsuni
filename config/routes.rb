Katsuni::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :boards do
    resources :posts
  end

  root :to => "boards#index"
end
