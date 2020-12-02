require 'test_helper'

class VisitsDownloadServiceTest < ActiveSupport::TestCase
  setup do
    @host = hosts(:cafe)
    @date = Date.new(2020, 1, 1)
  end

  test '#to_csv' do
    jims_visit = visits(:jim_cafe_20200101)
    pams_visit = visits(:pam_cafe_20200101)

    assert jims_visit.downloaded_at.nil?
    assert pams_visit.downloaded_at.nil?

    copy_visit!(jims_visit, '2020-01-01 23:00')
    copy_visit!(jims_visit, '2020-01-02 10:00')
    copy_visit!(pams_visit, '2020-01-02 10:00')
    copy_visit!(jims_visit, '2020-01-03 10:00')
    copy_visit!(pams_visit, '2020-01-03 10:00')

    download_time = DateTime.new(2020, 1, 4, 16, 0, 0)
    travel_to download_time do
      assert_difference -> { Visit.where(downloaded_at: download_time).count }, +2 do
        VisitsDownloadService.new(@host, @date).to_csv.tap do |csv|
          assert_equal file_fixture('csv/cafe_visits_2020-01-01.csv').read, csv
        end
      end
    end

    assert jims_visit.reload.downloaded_at.present?
    assert pams_visit.reload.downloaded_at.present?
  end

  test '#filename' do
    assert_equal 'visits_2020-01-01.csv', VisitsDownloadService.new(@host, @date).filename
  end
end
