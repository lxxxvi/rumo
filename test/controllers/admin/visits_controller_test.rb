require 'test_helper'

class Admin::VisitsControllerTest < ActionDispatch::IntegrationTest
  test 'get index'
  test 'cannot get index, if not signed in'
end
