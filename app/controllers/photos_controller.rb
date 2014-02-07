class PhotosController < ApplicationController
    
  load_and_authorize_resource :listing
  #load_and_authorize_resource through: :listing, shallow: true

  def index
    @photos = @listing.photos
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end


  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end


  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end


  def create
    @photo = @listing.photos.new(photo_params)
    if @photo.save
      puts "I saved it"
      head 200, :content_type => 'text/html'
    else
      render :json => { "errors" => @photo.errors } 
    end
  end


  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to listing_photos_path(@listing) }
      format.json { head :no_content }
    end
  end
end


private 
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:listing_id, :photo)
    end
