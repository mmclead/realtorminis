class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    url = user_signed_in? ? current_user : root_url
    redirect_to url, :alert => exception.message.present? ? exception.message : "You don't have permission for that."
  end

end
