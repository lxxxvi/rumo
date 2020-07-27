require 'test_helper'

class VisitsRetentionServiceTest < ActiveSupport::TestCase
  test '.cleanup!' do
    reference_time = Time.zone.local(2020, 1, 15, 13, 0, 0)

    travel_to reference_time do
      assert_no_difference -> { Visit.count } do
        VisitsRetentionService.cleanup!
      end
    end

    travel_to reference_time + 1.minute do
      assert_difference -> { Visit.count }, -2 do
        VisitsRetentionService.cleanup!
      end
    end
  end
end
