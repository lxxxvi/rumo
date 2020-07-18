require 'test_helper'

class Admin::VisitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @host = hosts(:cafe)
  end

  test 'get index' do
    sign_in @host

    get admin_visits_path
    assert_response :success
  end

  test 'cannot get index, if not signed in' do
    sign_out @host

    get admin_visits_path
    assert_redirected_to_sign_in
  end
end
