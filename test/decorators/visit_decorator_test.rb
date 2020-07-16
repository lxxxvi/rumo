require 'test_helper'

class VisitDecoratorTest < ActiveSupport::TestCase
  setup do
    @visit = visits(:jim_cafe_20200101)
  end

  test '#display_visited_at_in_hosts_time_zone' do
    assert_equal '2020-01-01 14:00', @visit.decorate.display_visited_at_in_hosts_time_zone
  end

  test '#display_status, unconfirmed' do
    assert_equal 'Unconfirmed', @visit.decorate.display_status
  end

  test '#visited_at_in_hosts_time_zone' do
    assert_equal Time.new(2020, 1, 1, 14, 0, 0, '+01:00'), @visit.decorate.visited_at_in_hosts_time_zone
  end
end
