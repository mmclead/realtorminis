class ListingsController < ApplicationController
  include ListingsHelper
  include PurchaseableControllerHelper
  # before_filter :find_listing_by_slug
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user, shallow: true, :find_by => :slug

  before_filter :set_profile, :set_content_location, :set_web_address, only: [:show, :preview]

  def index 
    @listings = @listings.not_deleted.order(created_at: :desc)
  end

  def show
    render 'show', id: @listing.id, layout: "preview_listing"
  end


  def create
    @listing = Listing.new(listing_params)
    @listing.user = @user
    respond_to do |format|
      if @listing.save
        format.html { redirect_to [@user, @listing], notice: 'Listing was successfully created.' }
        format.json { render action: 'show', status: :created, location: @listing }
      else
        format.html { render action: 'new' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @photos = @listing.photos
    @photo_count = Photo.unscoped.where(listing_id: @listing.id).count
  end

  def update
    if listing_params[:active] == "true"
      charge_customer_with_stripe(Rails.configuration.prices[:basic_listing], params, @listing) unless @listing.is_paid_for?
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
          format.html { redirect_to [@user,@listing], notice: 'Listing was successfully updated.' }
        else
          format.html { redirect_to user_listings_path(@user), notice: 'Listing was successfully updated.' }
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

  def publish
    render_and_set_site_code
    respond_to do |format|
      if @listing.publish!
        format.json { head :no_content }
        format.js {head :no_content, status: :success }
      else
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
  end

  def set_web_address
    @listing.web_address ||= request.original_url 
  end

  def set_content_location
    @cdn_url = ENV['AWS_CDN_NAME']
  end
    
  def listing_params
    params.require(:listing).permit(:address, :title, :price, :video_link, :bedrooms, :bathrooms, :sq_ft, :sold, :short_description, :description, :web_address, :user, :user_id, :active)
  end
end
