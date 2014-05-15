class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos.map(&:to_jq_upload) }
    end
  end

  # POST /photos
  # POST /photos.json
  def create
    # this line allows for compatibility with `ProtectedAttributes` or `StrongParameters`
    parameters = params.require(:photo).permit(:url, :bucket, :key)
    @photo = Photo.new(parameters)
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
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end

  # used for s3_uploader
  def generate_key
    uid = SecureRandom.uuid.gsub(/-/,'')

    render json: {
      key: "uploads/#{uid}/#{params[:filename]}",
      success_action_redirect: "/"
    }
  end
end
