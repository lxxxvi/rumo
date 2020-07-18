class ApplicationController < ActionController::Base
  before_action :initialize_uuid
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private

  def after_sign_in_path_for(_resource)
    admin_root_path
  end

  def initialize_uuid
    session[:uuid] ||= cookies.signed[:uuid] || SecureRandom.uuid
    cookies.signed[:uuid] = session[:uuid]
  end
end
