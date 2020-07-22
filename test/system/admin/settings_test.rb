require 'application_system_test_case'

class Admin::SettingsTest < ApplicationSystemTestCase
  test 'admin changes name' do
    sign_in hosts(:cafe)

    click_on 'Account settings'
    assert_link 'Back', href: '/admin'

    assert_selector 'h1', text: 'Account settings'

    assert_changes -> { find_field('Name').value }, to: 'Cafe Perfettissimo' do
      fill_in 'Name', with: 'Cafe Perfettissimo'
      click_on 'Edit settings'
    end
  end
end
