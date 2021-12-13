# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true

  before_create :apply_confirmation_token

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.authenticate(submitted_password)
  end

  def profile_pic?
    resource_path = File.join('images', 'profiles', "#{id}.png")
    file_path = File.join('public', resource_path)
    puts File.join('public', resource_path)
    puts File.exist? file_path
    File.exist? file_path
  end

  private

  def apply_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s if confirmation_token.blank?
  end
end
