require 'application_system_test_case'

class DatingsTest < ApplicationSystemTestCase
  setup do
    @driver = Capybara.current_session.driver.browser
  end

  test 'check that datings app works via selenium' do
    User.create(
      name: 'name', email: 'grigorypanko@gmail.com', password: 'secret',
      password_confirmation: 'secret', email_confirmed: true
    )
    @driver.navigate.to sessions_welcome_url
    @driver.find_element(:id, 'login').click
    @driver.find_element(:id, 'email').click
    @driver.find_element(:id, 'email').send_keys('grigorypanko@gmail.com')
    @driver.find_element(:id, 'password').click
    @driver.find_element(:id, 'password').send_keys('secret')
    @driver.find_element(:id, 'login-submit').click

    Selenium::WebDriver::Wait.new(timeout: 2).until { @driver.find_element(id: 'update-profile-form') }

    @driver.find_element(id: 'choose-dialogs').click
    assert @driver.find_element(class: 'profile').style('display').match('none')
  end
end
