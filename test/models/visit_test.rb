require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  setup do
    @visit = visits(:jim_cafe_20200101)
  end

  test '.save' do
    host = hosts(:cafe)
    visit = Visit.new

    assert_not visit.valid?

    assert_difference -> { Visit.count } do
      visit.assign_attributes(host: host, uuid: 'UUID', token: 'TOKEN', name: 'name', contact: 'contact')
      visit.save!
    end
  end

  test 'validates uniqueness of tokens within host' do
    visit_copy = @visit.dup

    assert_not visit_copy.validate
    assert_equal ['has already been taken'], visit_copy.errors[:token]
  end

  test 'initializes columns' do
    visit = Visit.new

    target_time = Time.new(2020, 2, 2, 15, 0, 0)

    travel_to target_time do
      visit.validate
      assert_match /[[:alnum:]]{5}/, visit.token
      assert_equal target_time, visit.visited_at
    end
  end

  test '.confirmed / .unconfirmed' do
    assert_difference -> { Visit.confirmed.count }, 1 do
      assert_difference -> { Visit.unconfirmed.count }, -1 do
        @visit.confirm!
      end
    end
  end

  test '.of_uuid' do
    assert_difference -> { Visit.of_uuid("11111111-1111-1111-1111-111111111111").count }, -1 do
      @visit.update!(uuid: 'another-uuid')
    end
  end

  test '#to_param' do
    assert_equal 'JIMCAFETOKEN', @visit.to_param
  end

  test '#confirm!, #confirmed? and #status' do
    assert_equal :rejected, Visit.new.status

    assert_changes -> { @visit.status }, from: :unconfirmed, to: :confirmed do
      assert_changes -> { @visit.confirmed? }, to: true do
        @visit.confirm!
      end
    end
  end

  test '#decorate' do
    assert_equal VisitDecorator, @visit.decorate.class
  end
end
