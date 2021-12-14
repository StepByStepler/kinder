# frozen_string_literal: true

require 'json'

# Controller which handles everything when user is already logged in
class DatingsController < ApplicationController
  USER_QUERY = 'id != ? AND email_confirmed = 1 AND age IS NOT NULL'

  before_action :authenticate
  skip_before_action :verify_authenticity_token, only: [:update]

  def view; end

  def update
    params = update_params
    @current_user.update(params.except(:profile_pic))
    unless @current_user.save
      respond :bad_request, @current_user.errors.first.full_message
      return
    end

    update_profile_pic params[:profile_pic] if params.key?(:profile_pic)
    respond :ok, ''
  end

  def update_profile_pic(pic_data)
    image_path = File.join('public', 'images', 'profiles', "#{@current_user.id}.png")
    File.open(image_path, 'wb') { |f| f.write pic_data.read }
  end

  def update_params
    params.permit(:name, :profile_pic, :age, :description)
  end

  def random_profile
    user = User.where(USER_QUERY, @current_user.id).order(Arel.sql('RANDOM()')).first
    if user.nil?
      respond :bad_request, ''
      return
    end

    respond :bad_request, '' if user.nil?
    json = user.as_json(only: %i[id name age description]).merge({ 'has_pic' => user.profile_pic? })
    respond_json :ok, json
  end

  def save_reaction
    target_id = params[:user_id]
    is_like = params[:is_like]
    existing_reaction = Reaction.find_by_user_id_and_target_id(@current_user.id, target_id)
    if existing_reaction
      existing_reaction.is_like = is_like
      existing_reaction.save!
    else
      Reaction.create(user_id: @current_user.id, target_id: target_id, is_like: is_like)
    end
    check_likes @current_user.id, target_id
    respond :ok, ''
  end

  def check_likes(current_user_id, target_id)
    reaction1 = Reaction.find_by_user_id_and_target_id(current_user_id, target_id)
    return unless reaction1&.is_like

    reaction2 = Reaction.find_by_user_id_and_target_id(target_id, current_user_id)
    return unless reaction2&.is_like

    return if Dialog.find_by_user1_and_user2(current_user_id, target_id)
    return if Dialog.find_by_user2_and_user1(current_user_id, target_id)

    Dialog.create(user1: current_user_id, user2: target_id)
  end

  def send_message
    user_id = @current_user.id
    dialog = Dialog.find_by_id params[:dialog]
    return unless [dialog&.user1, dialog&.user2].include?(user_id)

    text = params[:text]
    Message.create(dialog: dialog.id, from: user_id, text: text)
    respond_json :ok, {}
  end

  def dialogs
    user_id = @current_user.id
    dialogs = Dialog.where(user1: user_id).or(Dialog.where(user2: user_id)).to_a.map { |d| dialog_to_hash d, user_id }
    respond_json :ok, dialogs
  end

  def messages
    user_id = @current_user.id
    dialog_id = params[:dialog]
    dialog = Dialog.find_by_id dialog_id
    return unless [dialog&.user1, dialog&.user2].include?(user_id)

    messages = Message.where(dialog: dialog_id).to_a.map { |msg| message_to_hash msg, user_id }
    respond_json :ok, messages
  end

  def dialog_to_hash(dialog, user_id)
    other_user_id = dialog.user1 == user_id ? dialog.user2 : dialog.user1
    other_user = User.find_by_id(other_user_id)
    {
      id: dialog.id,
      user_id: other_user_id,
      name: other_user.name,
      last_message: Message.where(dialog: dialog.id).last&.text || '',
      has_pic: other_user.profile_pic?
    }
  end

  def message_to_hash(message, user_id)
    {
      is_own: message.from == user_id,
      text: message.text
    }
  end
end
