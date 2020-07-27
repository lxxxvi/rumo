require 'test_helper'

class VisitsRetentionServiceTest < ActiveSupport::TestCase
  test '.remove_expired!' do
    reference_time = Time.zone.local(2020, 1, 15, 13, 0, 0)

    travel_to reference_time do
      assert_no_difference -> { Visit.count } do
        VisitsRetentionService.remove_expired!
      end
    end

    travel_to reference_time + 1.minute do
      assert_difference -> { Visit.count }, -2 do
        VisitsRetentionService.remove_expired!
      end
    end
  end
end
