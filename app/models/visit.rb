class Visit < ApplicationRecord
  belongs_to :host
  validates :visited_at, :contact, :token, presence: true

  before_validation :initialize_visited_at
  before_validation :initialize_token

  scope :of_uuid, ->(uuid) { where(uuid: uuid) }

  scope :antichronological, -> {
    order(visited_at: :desc).order(confirmed_at: :desc).order(:token)
  }

  scope :visited_at_around, ->(time = Time.zone.now) {
    from_time = time - 30.minutes
    to_time = time + 30.minutes
    where(visited_at: (from_time..to_time))
  }

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :unconfirmed, -> { where(confirmed_at: nil) }

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
