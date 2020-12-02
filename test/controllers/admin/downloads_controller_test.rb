require 'test_helper'

class Admin::DownloadsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    sign_in hosts(:cafe)
    get new_admin_download_path
    assert_response :success
  end

  test 'should post create' do
    sign_in hosts(:cafe)
    post admin_downloads_path, params: {
      admin_download: {
        selected_date: '2020-01-01'
      }
    }

    assert_response :success

    assert_equal file_fixture('csv/cafe_visits_2020-01-01.csv').read, response.body
  end

  test 'should not post create with invalid params' do
    sign_in hosts(:cafe)
    post admin_downloads_path, params: {
      admin_download: {
        selected_date: '2020-13-01'
      }
    }

    assert_response :success
  end
end
