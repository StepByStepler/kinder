require 'test_helper'

class DatingsControllerTest < ActionDispatch::IntegrationTest
  def get_user(name, is_admin: false)
    User.find_by_name_and_is_admin(name, is_admin) || User.create(
      name: name, email: "#{name}#{is_admin}@gmail.com", password: 'secret',
      password_confirmation: 'secret', is_admin: is_admin, email_confirmed: true
    )
  end

  def login_with_user(name, is_admin: false)
    get_user(name, is_admin: is_admin).tap do |user|
      get sessions_login_url, params: { email: user.email, password: 'secret' }
      assert_response :ok
    end
  end

  def generate_user_button_test(is_admin)
    login_with_user "admin-#{is_admin}", is_admin: is_admin
    get datings_view_url

    buttons_count = is_admin ? 1 : 0
    assert_select 'button', id: 'generate-user-btn', count: buttons_count
  end

  test 'should show generate user button for admin' do
    generate_user_button_test true
  end

  test 'should not show generate user button for non-admin' do
    generate_user_button_test false
  end

  test 'should save user reaction on somebody profile' do
    user = login_with_user 'test-user'
    target_user = get_user 'target-user'
    assert_nil Reaction.find_by_user_id_and_target_id user.id, target_user.id
    get datings_save_reaction_url, params: { user_id: target_user.id, is_like: true }

    reaction = Reaction.find_by_user_id_and_target_id user.id, target_user.id
    assert_not_nil reaction
    assert reaction.is_like
  end

  test 'should create dialog after mutual likes' do
    user1 = login_with_user 'user1'
    user2 = get_user 'user2'
    assert_nil Dialog.find_by_user1_and_user2 user1, user2
    get datings_save_reaction_url, params: { user_id: user2.id, is_like: true }
    get sessions_exit_url

    login_with_user 'user2'
    get datings_save_reaction_url, params: { user_id: user1.id, is_like: true }

    users = [user1.id, user2.id]
    dialog = Dialog.where('user1 IN (?) AND user2 IN (?)', users, users).first!
    assert_not_nil dialog
    assert_includes [user1.id, user2.id], dialog.user1
    assert_includes [user1.id, user2.id], dialog.user2
  end
end
