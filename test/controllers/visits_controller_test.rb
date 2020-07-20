require 'test_helper'

class VisitsControllerTest < ActionDispatch::IntegrationTest
  test 'get index' do
    get visits_path
    assert_response :success
  end

  test 'get new' do
    get visit_path(host_url_identifier: 'cafe')
    assert_response :success
  end

  test 'get new, wrong host_url_identifier' do
    assert_raises ActiveRecord::RecordNotFound do
      get visit_path('does-not-exist')
    end
  end

  test 'post create, invalid params' do
    assert_no_difference -> { Visit.count } do
      post visit_path(host_url_identifier: 'cafe'), params: build_params(name: '', contact: '')
      assert_response :success
    end
  end

  test 'post create, valid params' do
    assert_difference -> { Visit.count }, 1 do
      post visit_path(host_url_identifier: 'cafe'),
           params: build_params(name: '', contact: '0123456789', notes: 'these are the notes')
      assert_redirected_to visits_path
      follow_redirect!
      assert_response :success
    end

    Visit.last.tap do |visit|
      assert_equal '', visit.name
      assert_equal '0123456789', visit.contact
      assert_equal 'these are the notes', visit.notes
    end
  end

  def build_params(name:, contact:, notes: nil)
    {
      visit: {
        name: name,
        contact: contact,
        notes: notes
      }
    }
  end
end
