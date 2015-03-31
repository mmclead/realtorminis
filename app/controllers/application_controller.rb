class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_user
  
  def after_sign_in_path_for(resource_or_scope)
    current_user
  end

  def set_user
    @user = current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    url = user_signed_in? ? current_user : root_url
    redirect_to url, :alert => exception.message.present? ? exception.message : "You don't have permission for that."
  end

end
