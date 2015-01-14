class ProfilesController < ApplicationController
  load_and_authorize_resource :user
  respond_to :html, :json, :js 

  def show
    redirect_to @user
  end


  def edit
    @profile = @user.profile
  end

  def update
    @profile = @user.profile
    @profile.update_attributes(profile_params)
    debugger
    respond_with @profile
  end

 private

  def profile_params
    params.require(:profile).permit(:name, :web_site, :tag_line, :contact_email, :phone_number, :dre_number, :remote_profile_pic_url, :remote_logo_url, :profile_pic, :logo)
  end
end