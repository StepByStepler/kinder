# frozen_string_literal: true

# Base class for all application controllers
class ApplicationController < ActionController::Base
  around_action :switch_locale

  private

  def switch_locale(&action)
    locale_cookie = cookies[:locale]&.to_sym
    locale = I18n.locale_available?(locale_cookie) ? locale_cookie : I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  protected

  def current_user
    @current_user ||= session[:current_user_id] && User.find_by_id(session[:current_user_id])
  end

  def authenticate
    redirect_to root_path if current_user.nil? || !current_user.email_confirmed
  end
end
