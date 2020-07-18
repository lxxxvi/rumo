require 'test_helper'

class VisitChannelTest < ActionCable::Channel::TestCase
  test 'subscribes' do
    visit = visits(:jim_cafe_20200101)
    stub_connection current_uuid: visit.uuid

    subscribe token: 'JIMCAFETOKEN'
    assert subscription.confirmed?

    assert_has_stream_for visit
  end

  test 'not subscribes if wrong uuid/token' do
    visit = visits(:jim_cafe_20200101)
    stub_connection current_uuid: visit

    subscribe token: 'PAMCAFETOKEN'
    assert_no_streams
  end
end
