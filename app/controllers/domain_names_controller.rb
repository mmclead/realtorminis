class DomainNamesController < ApplicationController
  load_and_authorize_resource :user
  before_filter :set_listing, only: [:create]
  respond_to :js, :json

  include PurchaseableControllerHelper

  def create
    @listing.domain_names.build(domain_name_params)
    #do some stripe stuff her
    #then save it
    #return something useful
  end

  def check_availability
    domain_name = DomainName.new(name: params[:name])
    render json: {available: domain_name.domain_is_available?}
  end


 private

  def set_listing
    @listing = @user.listings.where(id: domain_name_params[:listing_id])
  end

  def domain_name_params 
    params.require(:domain_name).permit(:listing_id, :name)
  end

end

