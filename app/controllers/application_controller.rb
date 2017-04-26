class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def access_denied(exception)
    redirect_to new_admin_keypad_path, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      new_admin_keypad_path
    end
  end
end
