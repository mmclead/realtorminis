class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :must_be_logged_in, :set_user

  def after_sign_in_path_for(resource_or_scope)
    if current_user.profile_hash.empty?
      user_path(current_user)
    else
      listings_path
    end
  end

  def set_user
    @user = current_user
  end

  def must_be_logged_in
    redirect_to root_url unless user_signed_in?
  end

  rescue_from CanCan::AccessDenied do |exception|
    url = user_signed_in? ? listings_path : root_url
    redirect_to url, :alert => exception.message.present? ? exception.message : "You don't have permission for that."
  end

end
