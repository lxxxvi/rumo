require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'elements on public home page' do
    visit '/'

    assert_selector 'h1', text: 'Welcome'
    assert_selector 'h2', text: 'For guest'
    assert_selector 'h2', text: 'For hosts'

    # guest section
    assert_selector 'section#guest' do
      assert_selector 'h3', text: 'Visit a host'
      assert_selector 'form', count: 1
    end

    # host section
    assert_selector 'section#host' do
      assert_selector 'h3', text: 'Register'
      assert_link 'Sign up'
      assert_link 'Sign in'
    end
  end
end
