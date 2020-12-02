require 'test_helper'

class Admin::DownloadFormTest < ActiveSupport::TestCase
  test '#date_select_options, 0 visit' do
    host = hosts(:cafe)
    host.visits.destroy_all

    assert_date_select_options([], host)
  end

  test '#date_select_options, 1 visit' do
    host = hosts(:cinema)

    assert_date_select_options([['2020-01-01 (1 visit)', '2020-01-01']], host)
  end

  test '#date_select_options, 2 visits' do
    host = hosts(:cafe)

    assert_date_select_options([['2020-01-01 (2 visits)', '2020-01-01']], host)
  end

  test 'invalid selected_date' do
    form = Admin::DownloadForm.new(nil, selected_date: '2020-13-12')
    assert_not form.valid?
    assert_includes form.errors.to_a, 'Selected date is invalid'
  end

  test 'valid selected_date' do
    assert Admin::DownloadForm.new(nil, selected_date: '2020-12-12').valid?
  end

  private

  def assert_date_select_options(expected, host)
    Admin::DownloadForm.new(host).tap do |form|
      assert_equal expected, form.date_select_options
    end
  end
end
