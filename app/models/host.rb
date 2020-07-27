class Host < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :visits, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  validates :url_identifier, presence: true
  validates :url_identifier, uniqueness: true

  before_validation :initialize_url_identifier

  def visit_url
    Rails.application.routes.url_helpers.visit_url(host_url_identifier: self)
  end

  def to_param
    url_identifier
  end

  private

  def initialize_url_identifier
    self.url_identifier ||= SecureRandom.base58(4)
  end
end
