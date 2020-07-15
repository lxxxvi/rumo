class ApplicationController < ActionController::Base
  before_action :initialize_uuid

  private

  def initialize_uuid
    session[:uuid] ||= SecureRandom.uuid
    cookies.signed[:uuid] ||= session[:uuid]
  end
end
