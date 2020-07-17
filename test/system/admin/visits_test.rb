require "application_system_test_case"

class Admin::VisitsTest < ApplicationSystemTestCase
  test 'confirms a visit' do
    sign_in_and_goto_manage_visits

    assert_link '2 unconfirmed'
    assert_link '0 confirmed'

    assert_difference -> { find_visit_list_items.size }, -1 do
      find_visit_list_items.first.find_button('Confirm').click
    end

    assert_link '1 unconfirmed'
    assert_link '1 confirmed'
  end

  test 'removes a visit' do
    sign_in_and_goto_manage_visits

    assert_difference -> { find_visit_list_items.size }, -1 do
      find_visit_list_items.first.find_button('Remove').click
    end

    assert_link '1 unconfirmed'
    assert_link '0 confirmed'
  end

  test 'switches between unconfirmed and confirmed visits' do
    sign_in_and_goto_manage_visits

    click_on '2 unconfirmed'

    assert_difference -> { find_visit_list_items.size }, -1 do
      visits(:jim_cafe_20200101).confirm!
      refresh
    end

    click_on '1 confirmed'

    assert_difference -> { find_visit_list_items.size }, 1 do
      visits(:pam_cafe_20200101).confirm!
      refresh
    end
  end

  test 'switches between unconfirmed and confirmed visits, 0 visits' do
    Visit.destroy_all

    sign_in_and_goto_manage_visits

    click_on '0 unconfirmed'
    assert_equal 0, find_visit_list_items.size
    assert_text 'All caught up!'

    click_on '0 confirmed'
    assert_equal 0, find_visit_list_items.size
    assert_text 'Nothing here yet.'
  end

  private

  def sign_in_and_goto_manage_visits
    sign_in hosts(:cafe)
    click_on 'Manage visits'
    assert_selector 'h1', text: 'Manage visits'
  end

  def find_visit_list_items
    find_all("[data-controller=admin-visits] > div")
  end
end
