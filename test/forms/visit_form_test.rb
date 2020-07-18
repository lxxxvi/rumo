require 'test_helper'

class VisitFormTest < ActiveSupport::TestCase
  test '#save' do
    form = new_visit_form(name: 'Michael',
                          contact: '+123450-000',
                          uuid: 'uuid')

    assert_difference -> { Visit.count }, 1 do
      assert form.save
    end
  end

  test '#save, invalid params' do
    form = new_visit_form(name: '',
                          contact: '',
                          uuid: 'uuid')

    assert_not form.valid?
    assert_equal 1, form.errors[:contact].count
    assert_equal "can't be blank", form.errors[:contact].first
  end

  private

  def new_visit_form(params, host = hosts(:cafe))
    VisitForm.new(host.visits.new, params)
  end
end
