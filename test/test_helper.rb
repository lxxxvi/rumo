ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def copy_visit!(visit, target_visited_at)
    visit.dup.tap do |new_visit|
      new_visit.token = SecureRandom.alphanumeric
      new_visit.visited_at = target_visited_at
      new_visit.save!
    end
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def assert_redirected_to_sign_in
    assert_redirected_to new_host_session_path
    follow_redirect!
    assert_response :success
  end
end
