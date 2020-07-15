require "application_system_test_case"

class VisitsTest < ApplicationSystemTestCase
  test 'visits host "cafe" form' do
    host = hosts(:cafe)
    visit new_host_visit_path(host)
    assert_selector 'h1', text: 'Welcome to Cafe Perfetto'
  end
end
