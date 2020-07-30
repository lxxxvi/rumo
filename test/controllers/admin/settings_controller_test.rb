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

    host = hosts(:cafe)

    assert_changes -> { host.reload.updated_at } do
      patch admin_settings_path,
            params: {
              admin_settings: {
                name: 'Cafe superiore',
                url_identifier: 'cafe-cool',
                auto_confirm_visits: '1'
              }
            }
    end

    assert_equal 'Cafe superiore', host.name
    assert_equal 'cafe-cool', host.url_identifier
    assert host.auto_confirm_visits

    assert_redirected_to edit_admin_settings_path
    follow_redirect!
    assert_response :success
  end

  test 'cannot patch update, if not signed in' do
    sign_out hosts(:cafe)

    assert_no_changes -> { hosts(:cafe).reload.updated_at } do
      patch admin_settings_path, params: { admin_settings: { name: 'Cafe superiore' } }
    end

    assert_redirected_to_sign_in
  end
end
