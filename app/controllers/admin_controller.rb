# frozen_string_literal: true

require 'faker'
require 'open-uri'

# Controller for all administrator actions
class AdminController < ApplicationController
  RANDOM_PERSON_URL = 'https://thispersondoesnotexist.com/image'

  before_action :authenticate, :check_admin

  def generate_user
    name = Faker::Name.name
    email = "#{(Time.now.to_f.round(3) * 1000).to_i}@gmail.com"
    password = SecureRandom.urlsafe_base64.to_s
    age = rand(16..40)
    user = User.create(
      name: name, email: email, password: password, password_confirmation: password,
      email_confirmed: true, age: age
    )
    generate_picture user.id
    respond :ok, ''
  end

  def generate_picture(user_id)
    image = URI.parse(RANDOM_PERSON_URL).open.read
    image_path = File.join('public', 'images', 'profiles', "#{user_id}.png")
    File.open(image_path, 'wb') { |f| f.write image }
  end

  def check_admin
    redirect_to root_path unless current_user.is_admin
  end
end
