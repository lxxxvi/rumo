require 'test_helper'

class QrCodeServiceTest < ActiveSupport::TestCase
  test '#as_svg' do
    QrCodeService.new('https://foo.bar/baz').tap do |service|
      assert_equal file_fixture('qr_codes/foo_bar_baz.svg').read.chomp, service.as_svg
    end
  end
end
