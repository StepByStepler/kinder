Rails.application.routes.draw do
  get 'sessions/welcome'
  get 'sessions/login'
  get 'sessions/register'
  get 'sessions/confirm'
  get 'datings/view'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
  root to: 'sessions#welcome'
end
