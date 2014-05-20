class UsersController < ApplicationController
  load_and_authorize_resource
  def show
    @user = current_user
    @profile = @user.profile
    @profile_attributes = @user.profile.profile_hash
  end
end
