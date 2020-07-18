require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'get index' do
    get '/'
    assert_response :success
  end

  test 'post index, invalid params' do
    post '/', params: { goto_hosts_form: { host_url_identifier: '' } }
    assert_response :success

    post '/', params: { goto_hosts_form: { host_url_identifier: 'does-not-exist' } }
    assert_response :success
  end

  test 'post index, valid params' do
    post '/', params: { goto_hosts_form: { host_url_identifier: 'cafe' } }
    assert_redirected_to '/visit/cafe'
    follow_redirect!
    assert_response :success
  end
end
