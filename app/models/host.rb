class Host < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :visits

  def visit_url
    Rails.application.routes.url_helpers.visit_url(host_url_identifier: self)
  end

  def to_param
    url_identifier
  end
end
