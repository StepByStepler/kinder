# frozen_string_literal: true

require_relative '../mailers/confirmation_mailer'

# Controller which handles user logging in and registering
class SessionsController < ApplicationController
  def welcome; end

  def respond(status, message)
    respond_to do |format|
      format.all { render html: message, status: status }
    end
  end
  private :respond

  def login
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      respond :unauthorized, t('session.login.wrong_password')
    elsif !user.email_confirmed
      respond :unauthorized, t('session.login.not_confirmed')
    else
      respond :ok, ''
      session[:current_user_id] = user.id
    end
  end

  def register
    @user = User.new(user_params)

    if @user.save
      ConfirmationMailer.with(user: @user).confirmation.deliver_now
      respond :ok, t('session.login.not_confirmed')
    else
      respond :unauthorized, @user.errors.first.full_message
    end
  end

  def exit
    @_current_user = session[:current_user_id] = nil
    redirect_to root_url
  end

  def confirm
    user = User.find_by_confirmation_token(params[:token])
    if user
      user.email_confirmed = true
      user.save
      flash[:success] = t('session.register.confirm.success')
    else
      flash[:error] = t('session.register.confirm.error')
    end
    redirect_to sessions_welcome_url
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
