require 'test_helper'

class Admin::SettingsControllerTest < ActionDispatch::IntegrationTest
  test 'get edit' do
    sign_in hosts(:cafe)
    get edit_admin_settings_path
    assert_response :success
  end

  test 'cannot get edit, if not signed in' do
    sign_out hosts(:cafe)
    get edit_admin_settings_path
    assert_redirected_to_sign_in
  end

  test 'patch update' do
    sign_in hosts(:cafe)

    assert_changes -> { hosts(:cafe).reload.name }, to: 'Cafe superiore' do
      patch admin_settings_path, params: { admin_settings: { name: 'Cafe superiore' } }
    end

    assert_redirected_to edit_admin_settings_path
    follow_redirect!
    assert_response :success
  end

  test 'cannot patch update, if not signed in' do
    sign_out hosts(:cafe)

    assert_no_changes -> { hosts(:cafe).reload.name } do
      patch admin_settings_path, params: { admin_settings: { name: 'Cafe superiore' } }
    end

    assert_redirected_to_sign_in
  end
end
