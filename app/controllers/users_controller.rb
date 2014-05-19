class UsersController < ApplicationController
  load_and_authorize_resource
  def show
    @user = current_user
    @profile_attributes = @user.profile_hash
    puts @profile_attributes
  end
end
