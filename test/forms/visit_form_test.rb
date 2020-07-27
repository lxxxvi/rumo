require 'test_helper'

class VisitFormTest < ActiveSupport::TestCase
  test '#save without auto-confirm' do
    form = new_visit_form(hosts(:cafe),
                          name: 'Michael',
                          contact: '+123450-000',
                          uuid: 'uuid')

    assert_difference -> { Visit.unconfirmed.count }, 1 do
      assert form.save
    end
  end

  test '#save with auto-confirm' do
    form = new_visit_form(hosts(:cinema),
                          name: 'Angela',
                          contact: '+6556565',
                          uuid: 'uuid')

    assert_difference -> { Visit.confirmed.count }, 1 do
      assert form.save
    end
  end

  test '#save, invalid params' do
    form = new_visit_form(hosts(:cafe),
                          name: '',
                          contact: '',
                          uuid: 'uuid')

    assert_not form.valid?
    assert_equal 1, form.errors[:contact].count
    assert_equal "can't be blank", form.errors[:contact].first
  end

  private

  def new_visit_form(host, params)
    VisitForm.new(host.visits.new, params)
  end
end
