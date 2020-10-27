require 'test_helper'
require 'application_system_test_case'

class HostsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  test 'host signs up' do
    visit '/'

    within 'section#host' do
      click_on 'Sign up'
    end

    assert_selector 'h1', text: 'Sign up as a host'

    fill_in 'Name', with: "Moe's Tavern"
    fill_in 'Email', with: 'moe@simp.son'
    fill_in 'Password', with: 'abcdef'

    click_on 'Sign up'

    assert_selector 'h1', text: 'Admin area'
  end

  test 'host signs up, invalid params' do
    visit new_host_registration_path

    click_on 'Sign up'

    assert_selector 'h1', text: 'Sign up as a host'

    assert_selector '.field_with_errors input', count: 3
    error_messages = find_all('.error-message').map(&:text)
    assert_equal 1, error_messages.uniq.size
    assert_equal "can't be blank", error_messages.first
  end

  test 'host requests new and resets password' do
    visit new_host_session_path

    click_on 'Forgot your password?'
    assert_selector 'h1', text: 'Forgot your password?'
    fill_in 'Email', with: 'host@cinema.hollywood'

    assert_emails 1 do
      click_on 'Reset password'
    end

    assert_selector 'h1', text: 'Sign in'
    assert_selector '.flash.flash-notice',
                    text: 'You will receive an email with instructions on how to reset your password'

    sent_mail = ActionMailer::Base.deliveries.last

    assert_equal 'rumo@mail.mail', sent_mail.from.first
    assert_equal 'rumo@mail.mail', sent_mail.reply_to.first
    assert_equal 'host@cinema.hollywood', sent_mail.to.first
    assert_equal 'Reset password instructions', sent_mail.subject

    edit_password_link = Capybara.string(sent_mail.body.raw_source).find_link('Change my password')
    assert edit_password_link[:href].starts_with?('http://rumo.test/hosts/password/edit?reset_password_token=')

    digested_reset_password_token = extract_reset_password_token_from_url(edit_password_link[:href])

    visit edit_host_password_path(reset_password_token: digested_reset_password_token)

    assert_selector 'h1', text: 'Change your password'
    fill_in 'Password', with: 'new-secure-password'

    click_on 'Change my password'

    assert_selector 'h1', text: 'Admin area'
  end

  test 'host resets password, invalid params' do
    host = hosts(:cinema)
    digest, reset_password_token = Devise.token_generator.generate(host.class, :reset_password_token)
    host.update!(reset_password_token: reset_password_token, reset_password_sent_at: 1.minute.ago)

    visit edit_host_password_path(reset_password_token: digest)

    click_on 'Change my password'

    assert_equal 1, find_all('.field_with_errors input').count
    assert_equal "can't be blank", find('.error-message').text
  end

  test 'host resets password, invalid token' do
    visit edit_host_password_path(reset_password_token: 'invalid-token')
    fill_in 'Password', with: 'new-password'
    click_on 'Change my password'
    assert_equal 'Reset password token is invalid', find('.error-message').text
  end

  test 'host resets password, expired token' do
    host = hosts(:cinema)
    digest, reset_password_token = Devise.token_generator.generate(host.class, :reset_password_token)
    host.update!(reset_password_token: reset_password_token, reset_password_sent_at: 6.hours.ago)

    visit edit_host_password_path(reset_password_token: digest)
    fill_in 'Password', with: 'new-password'
    click_on 'Change my password'
    assert_equal 'Reset password token has expired, please request a new one', find('.error-message').text
  end

  test 'host requests new password, invalid params' do
    visit new_host_password_path

    # empty form
    click_on 'Reset password'
    assert_selector 'h1', text: 'Forgot your password?'
    assert_selector '.field_with_errors input', minimum: 1

    error_messages = find_all('.error-message').map(&:text)
    assert_equal 1, error_messages.size
    assert_equal "can't be blank", error_messages.first

    # inexistent mail address
    fill_in 'Email', with: 'a@b.c'
    click_on 'Reset password'

    assert_selector '.field_with_errors input', minimum: 1

    error_messages = find_all('.error-message').map(&:text)
    assert_equal 1, error_messages.size
    assert_equal 'not found', error_messages.first
  end

  test 'host signs in' do
    sign_in hosts(:cafe)
    assert_selector 'h1', text: 'Admin area'
  end

  test 'host signs in, invalid params' do
    Struct.new('Host', :email)
    invalid_host = Struct::Host.new('')
    password = ''

    sign_in invalid_host, password

    assert_selector 'h1', text: 'Sign in'
    assert_selector '.flash.flash-alert', text: 'Invalid Email or password.'
  end

  private

  def extract_reset_password_token_from_url(url)
    Rack::Utils.parse_query(URI(url).query)['reset_password_token']
  end
end
