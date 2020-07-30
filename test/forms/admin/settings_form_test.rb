require 'test_helper'

class Admin::SettingsFormTest < ActiveSupport::TestCase
  test 'save' do
    form = form_with(name: 'New name', url_identifier: 'cafe-cool', auto_confirm_visits: '1')

    assert form.save
    host = hosts(:cafe).reload

    assert_equal 'New name', host.name
    assert_equal 'cafe-cool', host.url_identifier
    assert host.auto_confirm_visits
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

  test 'invalid url_identifier' do
    form = form_with(url_identifier: 'Cafe Cool')
    assert_not form.valid?

    assert_equal 1, form.errors[:url_identifier].count
    assert_equal 'may only contain alphanumeric characters and dashes', form.errors[:url_identifier].first
  end

  private

  def form_with(host: hosts(:cafe), name: '', url_identifier: '', auto_confirm_visits: '')
    Admin::SettingsForm.new(host, name: name, url_identifier: url_identifier, auto_confirm_visits: auto_confirm_visits)
  end
end
