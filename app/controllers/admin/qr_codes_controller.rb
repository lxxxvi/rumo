class Admin::QrCodesController < Admin::BaseController
  layout 'qr_code'

  def show
    @qr_code = QrCodeService.new(current_host.visit_url)
  end
end
