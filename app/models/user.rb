# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :apply_confirmation_token

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.authenticate(submitted_password)
  end

  private

  def apply_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s if confirmation_token.blank?
  end
end
