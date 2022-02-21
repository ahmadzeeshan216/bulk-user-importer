Rails.application.routes.draw do

  resources :users, only: [] do
    collection do
      get :new_import
      post :import
    end
  end

  root to: 'users#new_import'
end
