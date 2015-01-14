class UsersController < ApplicationController
  respond_to :html, :json, :js

  load_and_authorize_resource
  def show
    @user = current_user
    @profile = @user.profile
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
  def profile_params
    params.require(:user).permit(:profile_attributes => 
      [:id, :name, :web_site, :tag_line, :contact_email, :phone_number, :dre_number, :profile_pic, :logo])
  end
end
