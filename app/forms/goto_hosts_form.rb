class GotoHostsForm
  include ActiveModel::Model

  validates :host_url_identifier, presence: true, if: :validatable?
  validate :host_exist, if: :validatable?

  attr_reader :host_url_identifier

  def initialize(params)
    @host_url_identifier = params&.fetch(:host_url_identifier, nil)
  end

  def host
    @host ||= Host.find_by(url_identifier: host_url_identifier)
  end

  def validatable?
    !host_url_identifier.nil?
  end

  private

  def host_exist
    if host_url_identifier.present? && host.nil?
      errors.add(:host_url_identifier, 'could not be found')
    end
  end
end
