# frozen_string_literal: true

# Class which sends confirmation email on user registration
class ConfirmationMailer < ActionMailer::Base
  default from: 'grigorypanko@gmail.com'

  def confirmation
    @user = params[:user]
    mail(to: @user.email, subject: t('session.register.confirm.subject'))
  end
end
