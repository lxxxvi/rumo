require 'test_helper'

class Admin::QrCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @host = hosts(:cafe)
  end

  test 'get show' do
    sign_in @host
  end

  test 'cannot get show, if not signed in' do
    sign_out @host
    get admin_qr_code_path
    assert_redirected_to_sign_in
  end
end
