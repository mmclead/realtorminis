class ListingsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user, shallow: true

  # GET /listings
  # GET /listings.json
  def index
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @profile = @user.profile
    @listing_url = @listing.web_address || request.original_url 
    @photos = @listing.photos
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
    puts params
    debugger
    respond_to do |format|
      if @listing.update_attributes(listing_params)
        format.html { redirect_to [@user, @listing], notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
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
      debugger
      params.require(:listing).permit(:address, :title, :price, :bedrooms, :bathrooms, :sq_ft, :sold, :short_description, :description, :web_address, :user, :user_id, :active)
    end
end
