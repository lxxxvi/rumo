require 'test_helper'

class Admin::VisitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visit = visits(:jim_cafe_20200101)
    @host = hosts(:cafe)
  end

  test 'get index' do
    sign_in @host

    get admin_visits_path
    assert_response :success
  end

  test 'cannot get index, if not signed in' do
    sign_out @host

    get admin_visits_path
    assert_redirected_to_sign_in
  end

  test 'put confirm' do
    sign_in @host

    assert_changes -> { @visit.reload.confirmed? }, to: true do
      put admin_visit_path(@visit), params: { admin_visit: { notes: 'Table 33' } }
    end

    assert_equal 'Table 33', @visit.notes

    assert_redirected_to admin_visits_path
    follow_redirect!
    assert_response :success
  end

  test 'delete visit' do
    sign_in @host

    assert_difference -> { Visit.count }, -1 do
      delete admin_visit_path(@visit)
    end

    assert_redirected_to admin_visits_path
    follow_redirect!
    assert_response :success
  end

  test 'cannot put, if visit belongs to another host' do
    sign_in @host
    foreign_visit = visits(:mike_cinema_20200101)

    assert_raises ActiveRecord::RecordNotFound do
      put admin_visit_path(foreign_visit)
    end
  end

  test 'cannot put, if not signed in' do
    sign_out @host

    assert_no_changes -> { @visit.reload.confirmed? } do
      put admin_visit_path(@visit)
      assert_redirected_to_sign_in
    end
  end

  test 'cannot delete, if visit belongs to another host' do
    sign_in @host
    foreign_visit = visits(:mike_cinema_20200101)

    assert_raises ActiveRecord::RecordNotFound do
      delete admin_visit_path(foreign_visit)
    end
  end

  test 'cannot delete, if not signed in' do
    sign_out @host

    assert_no_changes -> { @visit.reload.confirmed? } do
      delete admin_visit_path(@visit)
      assert_redirected_to_sign_in
    end
  end
end
