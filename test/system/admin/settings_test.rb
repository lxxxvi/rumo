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

  test 'admin changes url identifier' do
    sign_in hosts(:cafe)

    click_on 'Account settings'

    assert_changes -> { find_field('URL identifier').value }, to: 'cafe-cool' do
      fill_in 'URL identifier', with: 'cafe-cool'
      click_on 'Edit settings'
    end
  end

  test 'admin toggles auto-confirm' do
    sign_in hosts(:cafe)

    click_on 'Account settings'

    assert_changes -> { find_field('Auto-confirm visits').checked? }, to: true do
      check 'Auto-confirm visits'
      click_on 'Edit settings'
    end

    assert_changes -> { find_field('Auto-confirm visits').checked? }, to: false do
      uncheck 'Auto-confirm visits'
      click_on 'Edit settings'
    end
  end

  test 'admin submits invalid form' do
    sign_in hosts(:cafe)

    click_on 'Account settings'
    fill_in 'Name', with: ''
    fill_in 'URL identifier', with: ''

    click_on 'Edit settings'

    assert_selector '.field_with_errors', minimum: 1

    assert_link 'Cancel', href: '/admin/settings/edit'
  end

  test 'visit url preview' do
    Capybara.using_driver(:selenium_chrome_headless) do
      sign_in hosts(:cafe)

      click_on 'Account settings'

      url_identifier_field = find_field('URL identifier')

      assert_changes -> { find('output').value }, from: 'cafe', to: 'cafe-cool' do
        url_identifier_field.send_keys '-cool'
      end
    end
  end

  test 'admin disables notes field' do
    sign_in hosts(:cafe)

    click_on 'Account settings'

    assert_changes -> { find_field("Show 'Notes' field").checked? }, to: false do
      uncheck "Show 'Notes' field"
      click_on 'Edit settings'
    end
  end

  test 'admin writes custom notes text' do
    sign_in hosts(:cafe)

    click_on 'Account settings'

    assert_changes -> { find_field('Notes text').value }, from: '', to: 'Provide the table number' do
      fill_in 'Notes text', with: 'Provide the table number'
      click_on 'Edit settings'
      refresh
    end
  end
end
