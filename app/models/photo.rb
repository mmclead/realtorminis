class Photo < ActiveRecord::Base
  belongs_to :listing

  mount_uploader :photo, PhotoUploader


  def filename
    File.basename(photo.path)
  end
end
