require 'application_system_test_case'

class Admin::HomeTest < ApplicationSystemTestCase
  test 'elements on home page' do
    sign_in hosts(:cafe)

    assert_selector 'h1', text: 'Admin area'
    click_on 'Show QR code'
    click_on 'Back'

    click_on 'Manage visits'
    click_on 'Back'

    assert_link 'Sign out'
  end

  test 'signs out' do
    sign_in hosts(:cafe)
    click_on 'Sign out'
    assert_selector 'h1', text: 'Rumo is a digital guestlist'
    visit admin_root_path
    assert_selector 'h1', text: 'Sign in'
  end
end
