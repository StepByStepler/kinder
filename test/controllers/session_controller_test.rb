require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # проверка того, что пользователь может зайти на страницу аутентификации
  test 'should get welcome page' do
    get sessions_welcome_url
    assert_response :success
  end

  # проверка того, что регистрация работает корректно
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

  # проверка того, что аутентификация работает корректно (до подтверждения почты не позволяет войти в аккаунт,
  # после подтверждения почты позволяет)
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

  # проверка того, что с неправильными данными пользователю не дает войти в аккаунт
  test 'should forbid logging in with incorrect credentials' do
    get sessions_login_url, params: { email: 'testmail@gmail.com', password: 'wrong_password' }
    assert_response :unauthorized
  end

  # проверка того, что без аутентификации пользователю не дает войти на страницу знакомств
  test 'should forbid visiting datings page without login' do
    get datings_view_url
    assert_redirected_to root_url
  end
end
