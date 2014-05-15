class Photo < ActiveRecord::Base
  belongs_to :listing

  mount_uploader :photo, PhotoUploader

  def filename
    File.basename(photo.path)
  end

  def to_jq_upload
    {
      "name" => read_attribute(:photo),
      "size" => photo.size,
      "url" => photo.url,
      "thumbnail_url" => photo.thumb.url,
      "delete_url" => photo_path(:id => id),
      "delete_type" => "DELETE"
    }
  end

end

