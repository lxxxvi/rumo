require 'test_helper'

class Admin::SettingsFormTest < ActiveSupport::TestCase
  test 'save' do
    form = form_with(name: 'New name')
    assert form.save
    assert_equal 'New name', hosts(:cafe).reload.name
  end

  test 'save, missing name' do
    form = form_with(name: '')
    assert_not form.save
    assert_equal 1, form.errors[:name].count
    assert_equal "can't be blank", form.errors[:name].first
  end

  test 'save, duplicate name' do
    cafe_host = hosts(:cafe)
    cinema_host = hosts(:cinema)

    form = form_with(host: cafe_host, name: cinema_host.name)

    assert_not form.save
    assert_equal 1, form.errors[:name].count
    assert_equal 'has already been taken', form.errors[:name].first
  end

  private

  def form_with(host: hosts(:cafe), name: '')
    Admin::SettingsForm.new(host, name: name)
  end
end
