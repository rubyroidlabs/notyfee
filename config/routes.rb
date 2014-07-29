Rails.application.routes.draw do
  devise_for :users
  root 'notifications#index'
  resources :notifications do
    member do
      put :toggle_paid
    end
  end
end
