Katsuni::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :boards do
    resources :posts do
      collection do
        post :delete_multiple
      end
    end
  end

  root :to => "boards#index"
end
