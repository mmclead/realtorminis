class SitesController < ApplicationController
  load_and_authorize_resource :user

  def index
    @site = @user.listings.active
  end

  def show
    @site = @user.listings.find(params[:id])
  end

end
