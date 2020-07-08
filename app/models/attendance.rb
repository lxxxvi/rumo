class Attendance < ApplicationRecord
  validates :attended_on, :contact, :token, presence: true

  before_validation :initialize_attended_on
  before_validation :initialize_token

  scope :antichronological, -> {
    order(attended_on: :desc).order(confirmed_at: :desc).order(:token)
  }

  def to_param
    token
  end

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    return if confirmed?

    update!(confirmed_at: Time.zone.now)
  end

  def status
    return :rejected if destroyed? || new_record?
    return :confirmed if confirmed?

    :unconfirmed
  end

  def decorate
    @decorate ||= AttendanceDecorator.new(self)
  end

  private

  def initialize_attended_on
    self.attended_on ||= Time.zone.today
  end

  def initialize_token
    self.token ||= SecureRandom.base58(5)
  end
end
