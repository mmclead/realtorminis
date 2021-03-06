class PhotosController < ApplicationController

  load_and_authorize_resource :listing

  # GET /photos
  # GET /photos.json
  def index
    if params[:reverse]
      @photos = @listing.photos.order(order: :desc)
    else
      @photos = @listing.photos.order(order: :asc)
    end
    @photo_count = Photo.unscoped.where(listing_id: @listing.id).count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos.map(&:to_jq_upload) }
    end
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = @listing.photos.new(photo_params)
    respond_to do |format|
      if @photo.save
        format.html {
          render :json => @photo.to_jq_upload,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: @photo.to_jq_upload, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def sort_photos
    #example sort_photos_params  {"photos"=>["photo_138", "photo_136", "photo_137"]}
    respond_to do |format|
      photo_ids = params[:photos].join(",").gsub("photo_", "").split(",")
      photo_updates = photo_ids.map.with_index{|photo_id, index| {order: index} }.to_a
      if Photo.transaction { Photo.update(photo_ids, photo_updates) }
        format.js {head :no_content, status: :success }
      else
        format.js { render json: {error: 'Could not update photos'}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = @listing.photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { render json: { id: params[:id] } }
      format.xml  { head :no_content }
    end
  end

  # used for s3_uploader
  def generate_key
    uid = listing_address.parameterize + "-#{params[:count]}" + File.extname(params[:filename])

    render json: {
      key: "listings/#{@listing.id}/photos/#{uid}",
      success_action_redirect: "/"
    }
  end

  private

    def listing_address
      if @listing.address.present? 
        @listing.address
      else
        "listing-#{@listing.id}"
      end
    end
    
    def photo_params
      params.require(:photo).permit(:url, :bucket, :key, :listing_id, :file_content_type, :file_size, :order)
    end
end
