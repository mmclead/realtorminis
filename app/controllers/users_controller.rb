class UsersController < ApplicationController
  respond_to :html, :json, :js

  before_filter :set_user, :get_or_set_profile, only: :show

  def show
    @profile_attributes = @user.profile.profile_hash
  end


  def edit

  end

  def update
    @user.attributes = profile_params

    if @user.save
      flash[:success] = "Updated profile" 
    end
    respond_with @user
  end

 private

  def set_user
    @user = current_user
  end

  def get_or_set_profile
    @user.create_profile unless @user.profile
    @profile = @user.profile
  end

  def profile_params
    params.require(:user).permit(:profile_attributes => 
      [:id, :name, :web_site, :tag_line, :contact_email, :phone_number, :dre_number, :profile_pic, :logo]
    )
  end
end
