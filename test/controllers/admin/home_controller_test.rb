require 'test_helper'

class Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  test 'get index'
  test 'cannot get index, if not signed in'
end
