class QrCodeService
  def initialize(url)
    @url = url
  end

  def qr_code
    @qr_code ||= RQRCode::QRCode.new(url)
  end

  def as_svg
    qr_code.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
  end

  attr_reader :url
end
