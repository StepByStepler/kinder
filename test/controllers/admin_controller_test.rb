require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test 'should forbid generating user when not logged in' do
    get admin_generate_user_url
    assert_redirected_to root_url
  end

  test 'should forbid generating user for non-admin users' do
    user = User.create(
      name: 'name', email: 'email@gmail.com', password: 'pass',
      password_confirmation: 'pass', email_confirmed: true
    )
    get sessions_login_url, params: { email: user.email, password: 'pass' }
    assert_response :ok

    get admin_generate_user_url
    assert_redirected_to root_url
  end

  test 'should successfully generate user for admin' do
    user = User.create(
      name: 'admin', email: 'admin@gmail.com', password: 'pass',
      password_confirmation: 'pass', email_confirmed: true, is_admin: true
    )
    get sessions_login_url, params: { email: user.email, password: 'pass' }
    assert_response :ok

    assert_difference 'User.count' do
      get admin_generate_user_url
      assert_response :ok
    end
  end
end
