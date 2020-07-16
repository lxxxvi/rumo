require 'test_helper'

class HostTest < ActiveSupport::TestCase
  test 'save' do
    host = Host.new

    assert_changes -> { host.save }, to: true do
      host.assign_attributes(
        name: 'Disco Galaxy',
        email: 'galaxy@galaxy.galaxy',
        password: 'the-big-secret'
      )
    end
  end

  test 'initializes columns' do
    host = Host.new

    assert_changes -> { host.url_identifier }, from: nil do
      host.validate
    end
  end

  test '#visit_url' do
    host = hosts(:cafe)
    assert_equal 'http://rumo.test/visit/cafe', host.visit_url
  end

  test '#to_param' do
    host = hosts(:cafe)
    assert_equal 'cafe', host.to_param
  end
end
