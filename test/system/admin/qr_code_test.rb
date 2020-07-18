require 'application_system_test_case'

class Admin::QrCodeTest < ApplicationSystemTestCase
  test 'display QR code' do
    sign_in hosts(:cafe)

    click_on 'Show QR code'

    assert_selector '.host-name', text: 'Cafe Perfetto'

    assert_selector '.host-url-identifier', text: 'cafe', exact_text: true

    within '.host-qr-code' do
      assert_selector 'svg'
      assert_text 'http://rumo.test/visit/cafe'
    end
  end
end
