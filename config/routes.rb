Rails.application.routes.draw do
  root 'notifications#index'
  resources :notifications do
    member do
      put :toggle_paid
    end
  end
end
