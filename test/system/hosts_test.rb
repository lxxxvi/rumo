require "application_system_test_case"

class HostsTest < ApplicationSystemTestCase
  test 'host signs up' do
    visit '/'

    within 'section#host' do
      click_on 'Sign up'
    end

    assert_selector 'h1', text: 'Sign up as host'

    fill_in 'Name', with: "Moe's Tavern"
    fill_in 'Email', with: 'moe@simp.son'
    fill_in 'Password', with: 'abcdef'

    click_on 'Sign up'

    assert_selector 'h1', text: 'Admin area'
  end

  test 'host signs up, invalid params' do
    visit new_host_registration_path

    click_on 'Sign up'

    assert_selector 'h1', text: 'Sign up as host'

    assert_selector '.field_with_errors input', count: 3
    error_messages = find_all('.error-message').map(&:text)
    assert_equal 1, error_messages.uniq.size
    assert_equal "can't be blank", error_messages.first
  end

  test 'host resets password' do
    visit new_host_session_path

    click_on 'Forgot your password?'
    assert_selector 'h2', text: 'Forgot your password?'
    fill_in 'Email', with: 'host@cinema.hollywood'

    skip # TODO: Implement reset
  end

  test 'host resets password, invalid params' do
    visit new_host_password_path

    click_on 'Send me reset password instructions'
    assert_selector 'h2', text: 'Forgot your password?'
    assert_selector '.field_with_errors input', minimum: 1

    skip # TODO: Test error messages
  end

  test 'host signs in' do
    sign_in hosts(:cafe)
    assert_selector 'h1', text: 'Admin area'
  end

  test 'host signs in, invalid params' do
    Struct.new("Host", :email)
    invalid_host = Struct::Host.new('')
    password = ''

    sign_in invalid_host, password

    assert_selector 'h1', text: 'Host sign in'
    assert_selector '.flash.flash-alert', text: 'Invalid Email or password.'
  end
end
