class ListingsController < ApplicationController
  include ListingsHelper
  include PurchaseableControllerHelper

  respond_to :json
  load_and_authorize_resource shallow: true, except: [:check_availability]
  skip_load_and_authorize_resource only: [:check_availability]
  before_filter :set_content_location, only: [:show, :index]
  before_filter :set_profile, :set_web_address, only: [:show]

  def index 
    @listings = @listings.not_deleted.order(updated_at: :desc)
    @supported_tlds = DomainName::SUPPORTED_TLDS
  end

  def show
    @photos = @listing.photos.order(order: :asc).order(created_at: :asc)
    render 'show', id: @listing.id, layout: "preview_listing"
  end


  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render action: 'show', status: :created, location: @listing }
      else
        format.html { render action: 'new' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @photo_count = Photo.unscoped.where(listing_id: @listing.id).count
  end

  def update
    if listing_params[:active] == "true"
      charge_customer_with_stripe(Rails.configuration.prices[:basic_listing], @listing.purchase_description, params, @listing) unless @listing.is_paid_for?
      render_and_set_site_code
      begin
        @listing.publish! 
      rescue
        @listing.errors[:publish] = "was not successful"
      end
    end
    respond_to do |format|
      if @listing.update_attributes(listing_params)
        if params[:preview] == true
          format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        else
          format.html { redirect_to listings_path, notice: 'Listing was successfully updated.' }
        end
        format.json { head :no_content }
        format.js { active_status(@listing) }
      else
        format.html { render action: 'edit' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
        format.js { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_availability
    available = {"available" => (Listing.where(web_address: params[:address].parameterize).count == 0)}
    respond_with available
  end

  def publish
    render_and_set_site_code
    if @listing.publish!
      render partial: "/listings/index/listing", locals: {listing: @listing} and return
    else
      respond_to do |format|
        format.json { render json: @listing.errors, status: :unprocessable_entity }
        format.js { render json: @listing.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
    end
  end

 private

  def render_and_set_site_code
    set_profile
    set_web_address
    set_content_location
    @creating_remote_site = true

    @listing.site_code = render_to_string 'show', id: @listing.id, format: :html, layout: 'preview_listing'
  end

  def set_profile
    @user ||= @listing.user
    @profile = @user.profile
    @photos = @listing.photos.order(order: :asc).order(created_at: :asc)
    @key_photo = @photos.first.key rescue nil
  end

  def set_web_address
    @listing.web_address ||= request.original_url 
  end

  def set_content_location
    @cdn_url = ENV['AWS_CDN_NAME']
  end
    
  def listing_params
    params.require(:listing).permit(:address, :city, :state, :zip, :title, :price, :video_link, :bedrooms, :bathrooms, :sq_ft, :sold, :short_description, :description, :web_address, :user, :user_id, :active)
  end
end
