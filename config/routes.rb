Rails.application.routes.draw do
  get 'sessions/welcome'
  get 'sessions/login'
  get 'sessions/register'
  get 'sessions/confirm'
  get 'sessions/exit'
  get 'datings/view'
  post 'datings/update'
  get 'datings/random-profile', to: DatingsController.action(:random_profile)
  get 'datings/save-reaction', to: DatingsController.action(:save_reaction)
  get 'datings/send-message', to: DatingsController.action(:send_message)
  get 'datings/dialogs'
  get 'datings/messages'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
  root to: 'sessions#welcome'
end
