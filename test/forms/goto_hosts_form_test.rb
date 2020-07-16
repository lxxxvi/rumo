require 'test_helper'

class GotoHostsFormTest < ActiveSupport::TestCase
  test '#validate success' do
    assert new_goto_hosts_form(host_url_identifier: 'cafe').valid?
  end

  test '#validatable?, params nil' do
    assert_not new_goto_hosts_form(nil).validatable?
  end

  test '#validate, host_url_identifier empty' do
    form = new_goto_hosts_form(host_url_identifier: '')

    assert_not form.valid?
    assert_equal 1, form.errors[:host_url_identifier].count
    assert_equal ["can't be blank"], form.errors[:host_url_identifier]
  end

  test '#validate, host_url_identifier inexistent' do
    form = new_goto_hosts_form(host_url_identifier: 'does-not-exist')

    assert_not form.valid?
    assert_equal 1, form.errors[:host_url_identifier].count
    assert_equal ["could not be found"], form.errors[:host_url_identifier]
  end

  private

  def new_goto_hosts_form(params)
    GotoHostsForm.new(params)
  end
end
