class PhotosController < ApplicationController

  load_and_authorize_resource :listing

  # GET /photos
  # GET /photos.json
  def index
    @photos = @listing.photos
    @photo_count = @listing.photos.unscoped.count+1

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

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = @listing.photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end

  # used for s3_uploader
  def generate_key
    uid = @listing.address.parameterize + "-#{params[:count]}" + File.extname(params[:filename])

    render json: {
      key: "listings/#{@listing.id}/photos/#{uid}",
      success_action_redirect: "/"
    }
  end

  private
    
    def photo_params
      params.require(:photo).permit(:url, :bucket, :key, :listing_id)
    end
end
