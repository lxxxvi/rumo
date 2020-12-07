require 'application_system_test_case'

class VisitsTest < ApplicationSystemTestCase
  test 'visitor gets to form by entering host url identifier' do
    visit '/'

    within('section#guest form') do
      fill_in "Enter your host's token", with: 'cafe'
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
    visit_cafe_with(name: 'Dwight Schrute', contact: '+1234-0000', notes: 'Table 34')
    assert_selector 'h1', text: 'My visits'
    assert_selector '.visits .visit', count: 1 do |element|
      element.assert_text('Dwight Schrute')
      element.assert_text('*****-0000')
      element.assert_text('Table 34')
    end
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
        within '.visits' do
          assert_selector '.text-status--unconfirmed', count: 1
          assert_selector '.text-status--confirmed', count: 0
          @visit_token = find('.visit:first-child')['data-synchronize-visit-token']

          assert_match(/[[:alnum:]]{5}/, @visit_token, 'Visit token could not be found on guest visits page')
        end
      end

      within_window admin_window do
        sign_in hosts(:cafe)
        click_on 'Manage visits'

        find("[data-visit-token=\"#{@visit_token}\"]").tap do |element|
          element.click # opens the action menu
          element.find_button('Confirm').click
        end
      end

      within_window guest_window do
        within '.visits' do
          assert_selector '.text-status--confirmed', count: 1
          assert_selector '.text-status--unconfirmed', count: 0
        end
      end
    end
  end

  test 'visitor sees visits on home page' do
    visit_cafe_with(name: 'Michael', contact: '+00-00')
    visit root_path

    within('section#my-visits') do
      assert_link 'Show my visits', href: '/visits'
    end
  end

  test 'notes field is not displayed when not enabled' do
    host = hosts(:cafe)

    visit visit_path(host_url_identifier: 'cafe')
    assert has_field?('Notes'), 'Notes should be displayed'
    assert_selector '.notes-text', text: 'Please provide table number'

    host.update(notes_enabled: false)

    visit visit_path(host_url_identifier: 'cafe')
    assert_not has_field?('Notes'), 'Notes should NOT be displayed'
  end

  test 'autofill form after first visit' do
    Capybara.using_driver(:selenium_chrome_headless) do
      visit_cafe_with(name: 'Andy Bernard', contact: '+1234-9999')

      visit visit_path(host_url_identifier: 'cinema-hollywood')

      assert_equal 'Andy Bernard', find_field('Name').value
      assert_equal '+1234-9999', find_field('Contact').value
    end
  end

  test 'visitor sees if their data has been downloaded' do
    visit_cafe_with(name: 'Michael', contact: '+00-00')
    last_visit = Visit.last

    reference_date = Time.new(2020, 6, 6, 7, 8, 9, 0)

    visit visits_path

    assert_selector '.visits .downloaded-at', text: 'This data has not been disclosed.'

    last_visit.update(downloaded_at: reference_date)
    refresh

    assert_selector '.visits .downloaded-at', text: 'This data has been disclosed on 2020-06-06 at 07:08 UTC.'
  end

  private

  def visit_cafe_with(name:, contact:, notes: nil)
    visit visit_path(host_url_identifier: 'cafe')

    fill_in 'Name', with: name
    fill_in 'Contact', with: contact
    fill_in 'Notes', with: notes

    click_on 'Share contact data'
  end
end
