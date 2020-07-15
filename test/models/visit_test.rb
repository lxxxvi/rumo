require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  test '.visited_at_around' do
    visit = visits(:jim_cafe_20200101)
    visit.update!(visited_at: '2020-01-01 13:00:00')

    assert_not_includes Visit.visited_at_around(Time.zone.parse('2020-01-01 12:29:00')), visit
    assert_includes Visit.visited_at_around(Time.zone.parse('2020-01-01 12:30:00')), visit
    assert_includes Visit.visited_at_around(Time.zone.parse('2020-01-01 13:30:00')), visit
    assert_not_includes Visit.visited_at_around(Time.zone.parse('2020-01-01 13:31:00')), visit
  end
end
