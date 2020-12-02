require 'test_helper'

class GroupVisitsByDateServiceTest < ActiveSupport::TestCase
  test '#visits_by_date cinema' do
    host = hosts(:cinema)
    visit = visits(:mike_cinema_20200101)

    copy_visit!(visit, '2020-01-02 10:00:00')
    copy_visit!(visit, '2020-01-02 11:00:00')
    copy_visit!(visit, '2020-01-02 23:00:00')
    copy_visit!(visit, '2020-01-03 10:00:00')

    GroupVisitsByDateService.new(host).visits_by_date.tap do |result|
      assert_equal 3, result.count

      # first row: 2020-01-01
      result.first.tap do |first_row|
        assert_equal Date.new(2020, 1, 1), first_row.date
        assert_equal 1, first_row.number_of_visits
      end

      # second row: 2020-01-02
      result.second.tap do |second_row|
        assert_equal Date.new(2020, 1, 2), second_row.date
        assert_equal 2, second_row.number_of_visits
      end

      # third row: 2020-01-03
      result.third.tap do |third_row|
        assert_equal Date.new(2020, 1, 3), third_row.date
        assert_equal 2, third_row.number_of_visits # 2 because of time zone!
      end
    end
  end
end
