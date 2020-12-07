class Visit < ApplicationRecord
  belongs_to :host
  validates :visited_at, :contact, :token, presence: true
  validates :token, uniqueness: { scope: :host_id }

  before_validation :initialize_visited_at
  before_validation :initialize_token

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :unconfirmed, -> { where(confirmed_at: nil) }
  scope :of_uuid, ->(uuid) { where(uuid: uuid) }

  scope :antichronological, -> {
    order(visited_at: :desc).order(confirmed_at: :desc).order(:token)
  }

  scope :visited_at_on_date_in_time_zone, ->(date, time_zone) {
    where(
      "date(visited_at AT TIME ZONE 'UTC' AT TIME ZONE :time_zone) = :date",
      date: date,
      time_zone: time_zone
    )
  }

  def to_param
    token
  end

  def confirmed?
    confirmed_at.present?
  end

  def downloaded?
    downloaded_at.present?
  end

  def set_confirmed_at
    self.confirmed_at ||= Time.zone.now
  end

  def status
    return :rejected if destroyed? || new_record?
    return :confirmed if confirmed?

    :unconfirmed
  end

  def decorate
    @decorate ||= VisitDecorator.new(self)
  end

  private

  def initialize_visited_at
    self.visited_at ||= Time.zone.now
  end

  def initialize_token
    self.token ||= SecureRandom.base58(5)
  end
end
