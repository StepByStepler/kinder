require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get welcome page' do
    get sessions_welcome_url
    assert_response :success
  end

  test 'should handle register properly' do
    assert_nil User.find_by_name('test_user')
    get sessions_register_url, params: {
      name: 'test_user',
      email: 'testmail@gmail.com',
      password: 'secret',
      password_confirmation: 'secret'
    }

    user = User.find_by_name('test_user')
    assert_not_nil user
    assert_not user.email_confirmed
    assert_response :success
  end

  test 'should handle login properly' do
    get sessions_register_url, params: {
      name: 'user1',
      email: 'testmail@gmail.com',
      password: 'secret',
      password_confirmation: 'secret'
    }
    assert_response :ok

    user = User.find_by_name('user1')
    get sessions_login_url, params: {
      email: user.email,
      password: 'secret'
    }
    assert_response :unauthorized

    get sessions_confirm_url, params: { token: user.confirmation_token }
    get sessions_login_url, params: {
      email: user.email,
      password: 'secret'
    }
    assert_response :ok
  end

  test 'should forbid logging in with incorrect credentials' do
    get sessions_login_url, params: { username: 'user1', password: 'wrong_password' }
    assert_response :unauthorized
  end

  test 'should forbid visiting datings page without login' do
    get datings_view_url
    assert_redirected_to root_url
  end
end
