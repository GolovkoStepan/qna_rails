# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[nickname])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[nickname email phone first_name last_name date_of_birth password])
  end

  def authorization_error
    head 403
  end
end
