require 'application_system_test_case'

class Admin::DownloadsTest < ApplicationSystemTestCase
  test 'elements on home page' do
    sign_in hosts(:cafe)

    click_on 'Download visits'

    select '2020-01-01 (2 visits)', from: 'Select date'

    click_on 'Download visits'

    assert_equal file_fixture('csv/cafe_visits_2020-01-01.csv').read, page.body
  end
end
