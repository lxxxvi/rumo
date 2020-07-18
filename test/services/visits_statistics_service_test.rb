require 'test_helper'

class VisitsStatisticsServiceTest < ActiveSupport::TestCase
  setup do
    @host = hosts(:cafe)
  end

  test '#statistics, 0 confirmed, 0 unconfirmed' do
    @host.visits.destroy_all
    assert_statistics confirmed: 0, unconfirmed: 0
  end

  test '#statistics, 0 confirmed, 2 unconfirmed' do
    assert_statistics confirmed: 0, unconfirmed: 2
  end

  test '#statistics, 1 confirmed, 1 unconfirmed' do
    @host.visits.first.confirm!
    assert_statistics confirmed: 1, unconfirmed: 1
  end

  test '#statistics, 2 confirmed, 0 unconfirmed' do
    @host.visits.map(&:confirm!)
    assert_statistics confirmed: 2, unconfirmed: 0
  end

  private

  def assert_statistics(confirmed:, unconfirmed:)
    VisitsStatisticsService.new(@host).tap do |service|
      assert_equal confirmed, service.statistics.confirmed
      assert_equal unconfirmed, service.statistics.unconfirmed
    end
  end
end
