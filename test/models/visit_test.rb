require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  test '.valid'
  test 'initializes columns'
  test '.confirmed / .unconfirmed'
  test '.of_uuid'
  test '#to_param'
  test '#confirmed?'
  test '#confirm!'
  test '#status'
  test '#decorate'
end
