Rails.application.routes.draw do
  get 'admin/generate_user'
  get 'sessions/welcome'
  get 'sessions/login'
  get 'sessions/register'
  get 'sessions/confirm'
  get 'sessions/exit'
  get 'datings/view'
  post 'datings/update'
  get 'datings/random_profile'
  get 'datings/save_reaction'
  get 'datings/send_message'
  get 'datings/dialogs'
  get 'datings/messages'

  root to: 'sessions#welcome'
end
