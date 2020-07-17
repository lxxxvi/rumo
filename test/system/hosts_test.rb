require "application_system_test_case"

class HostsTest < ApplicationSystemTestCase
  test 'host signs up' do
    visit '/'

    within 'section#host' do
      click_on 'Sign up'
    end

    assert_selector 'h1', text: 'Sign up as host'

    fill_in 'Name', with: "Moe's Tavern"
    fill_in 'Email', with: 'moe@simp.son'
    fill_in 'Password', with: 'abcdef'

    click_on 'Sign up'

    assert_selector 'h1', text: 'Admin area'
  end

  test 'host signs up, invalid params' do
    assert false
  end

  test 'host resets password' do
    assert false
  end

  test 'host resets password, invalid params' do
    assert false
  end

  test 'host signs in' do
    assert false
  end

  test 'host signs in, invalid params' do
    assert false
  end
end
