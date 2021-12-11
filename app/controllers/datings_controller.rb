# frozen_string_literal: true

# Controller which handles everything when user is already logged in
class DatingsController < ApplicationController
  before_action :authenticate
  skip_before_action :verify_authenticity_token, only: [:update]

  def view
  end

  def update
    params = update_params
    @current_user.update(params.except(:profile_pic))
    unless @current_user.save
      respond :bad_request, @user.errors.first.full_message
      return
    end

    puts params
    p params
    update_profile_pic params[:profile_pic] if params.key?(:profile_pic)
    respond :ok, ''
  end

  def update_profile_pic(pic_data)
    puts 'Updating profile pic'
    puts pic_data.original_filename
    image_path = File.join('public', 'images', 'profiles', "#{@current_user.id}.png")
    File.open(image_path, 'wb') { |f| f.write pic_data.read }
    # File.write image_path, pic_data.read
  end

  def update_params
    puts params
    params.permit(:name, :profile_pic)
  end
end
