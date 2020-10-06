require 'test_helper'
require 'capybara/rails'

Webdrivers::Chromedriver.update

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

  def sign_in(host, password = 'abc')
    visit new_host_session_path

    fill_in 'Email', with: host.email
    fill_in 'Password', with: password

    click_on 'Sign in'
  end
end
