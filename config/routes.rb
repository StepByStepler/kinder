Rails.application.routes.draw do
  get 'admin/generate-user', to: AdminController.action(:generate_user)
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

  root to: 'sessions#welcome'
end
