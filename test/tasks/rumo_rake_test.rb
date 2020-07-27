require 'test_helper'
require 'rake'

class RumoRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  test 'rumo:remove_expired' do
    travel_to Time.zone.local(2020, 1, 15, 13, 1) do
      assert_difference -> { Visit.count }, -2 do
        Rake::Task['rumo:remove_expired'].invoke
      end
    end
  end
end
