class Photo < ActiveRecord::Base
  belongs_to :listing

  mount_uploader :photo, PhotoUploader
end
