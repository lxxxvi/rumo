require 'test_helper'

class Admin::Visits::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @host = hosts(:cafe)
    @visit = visits(:jim_cafe_20200101)
  end

  test 'post create' do
    sign_in @host

    assert_changes -> { @visit.reload.confirmed? }, to: true do
      post admin_visit_confirmation_path(@visit)
      assert_redirected_to admin_visits_path
      follow_redirect!
      assert_response :success
    end
  end

  test 'cannot post create, if visit belongs to another host' do
    sign_in @host
    foreign_visit = visits(:mike_cinema_20200101)

    assert_raises ActiveRecord::RecordNotFound do
      post admin_visit_confirmation_path(foreign_visit)
    end
  end

  test 'cannot post create, if not signed in' do
    sign_out @host

    assert_no_changes -> { @visit.reload.confirmed? } do
      post admin_visit_confirmation_path(@visit)
      assert_redirected_to_sign_in
    end
  end
end
