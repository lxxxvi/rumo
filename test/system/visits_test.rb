require 'application_system_test_case'

class VisitsTest < ApplicationSystemTestCase
  test 'visitor gets to form by entering host url identifier' do
    visit '/'

    within('section#guest form') do
      fill_in "Enter your host's token manually", with: 'cafe'
      click_on 'Go'
    end

    assert_equal '/visit/cafe', current_path
    assert_selector 'h1', text: 'Cafe Perfetto'
  end

  test 'visitor submits form, invalid params' do
    visit_cafe_with(name: 'Dwight Schrute', contact: '')

    assert_selector 'h1', text: 'Cafe Perfetto'

    error_messages = find_all('.error-message')
    assert_equal 1, error_messages.count
    assert_equal "can't be blank", error_messages.first.text
  end

  test 'visitor submits form, valid params' do
    visit_cafe_with(name: 'Dwight Schrute', contact: '+1234-0000')
    assert_selector 'h1', text: 'My visits'
    assert_selector 'ul#visits li', count: 1
  end

  test 'visitor sees only own visits, 0 visits' do
    visit visits_path

    assert_text 'No visits found'
  end

  test 'visitor gets notified about confirmation' do
    Capybara.using_driver(:selenium_chrome_headless) do
      guest_window = open_new_window
      admin_window = open_new_window

      within_window guest_window do
        visit_cafe_with(name: 'Dwight Schrute', contact: '+1234-0000')
        within 'ul#visits' do
          assert_selector '.text-status-unconfirmed', count: 1
          assert_selector '.text-status-confirmed', count: 0
          @visit_token = find('li:first-child')['data-synchronize-visit-token']
          assert @visit_token.present?, 'Visit token could not be found on guest visits page'
        end
      end

      within_window admin_window do
        sign_in hosts(:cafe)
        click_on 'Manage visits'

        find("[data-visit-token=#{@visit_token}]").tap do |element|
          element.click # opens the action menu
          element.find_button('Confirm').click
        end
      end

      within_window guest_window do
        within 'ul#visits' do
          assert_selector '.text-status-confirmed', count: 1
          assert_selector '.text-status-unconfirmed', count: 0
        end
      end
    end
  end

  test 'visitor sees visits on home page' do
    visit_cafe_with(name: 'Michael', contact: '+00-00')
    visit root_path

    within('section#guest') do
      assert_link 'My visits', href: '/visits'
    end
  end

  private

  def visit_cafe_with(name:, contact:)
    visit visit_path(host_url_identifier: 'cafe')

    fill_in 'Name', with: name
    fill_in 'Contact', with: contact

    click_on 'Submit my contact data'
  end
end
