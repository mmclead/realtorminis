class ListingsController < ApplicationController
  # before_filter :find_listing_by_slug
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user, shallow: true, :find_by => :slug

  before_filter :set_profile
  # GET /listings
  # GET /listings.json
  def index
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @profile = @user.profile
    @listing.web_address ||= request.original_url 
  end

  def preview


  end

  # GET /listings/new
  def new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
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

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    debugger
    if listing_params[:active] == "true"
      @profile = @user.profile
      @listing_url = @listing.web_address || request.original_url 
      @photos = @listing.photos
      debugger
      @listing.site_code = render_to_string 'show', :id => @listing.id, :format => :html
    end
    respond_to do |format|
      debugger
      if @listing.update_attributes(listing_params)
        format.html { redirect_to [@user, @listing], notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
        format.js {head :no_content, status: :success }
      else
        format.html { render action: 'edit' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
        format.js { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
    end
  end

  private
    
    def listing_params
      params.require(:listing).permit(:address, :title, :price, :bedrooms, :bathrooms, :sq_ft, :sold, :short_description, :description, :web_address, :user, :user_id, :active)
    end
end
