require 'test_helper'

class Admin::VisitFormTest < ActiveSupport::TestCase
  test 'confirm' do
    visit = visits(:jim_cafe_20200101)

    form = Admin::VisitForm.new(visit, { notes: 'notes' })

    assert_difference -> { Visit.confirmed.count }, 1 do
      form.save
    end

    visit.reload
    assert_equal :confirmed, visit.status
    assert_equal 'notes', visit.notes
  end
end
