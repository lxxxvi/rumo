require 'test_helper'

class VisitsControllerTest < ActionDispatch::IntegrationTest
  test 'get index' do
    get visits_path
    assert_response :success
  end

  test 'get new' do
    get visit_path(host_url_identifier: 'cafe')
    assert_response :success
  end

  test 'get new, wrong host_url_identifier' do
    assert_raises ActiveRecord::RecordNotFound do
      get visit_path('does-not-exist')
    end
  end

  test 'post create, invalid params' do
    assert_no_difference -> { Visit.count } do
      post visit_path(host_url_identifier: 'cafe'), params: { visit: { name: '', contact: '' } }
      assert_response :success
    end
  end

  test 'post create, valid params' do
    assert_difference -> { Visit.count }, 1 do
      post visit_path(host_url_identifier: 'cafe'), params: { visit: { name: '', contact: '01234' } }
      assert_redirected_to visits_path
      follow_redirect!
      assert_response :success
    end
  end
end
