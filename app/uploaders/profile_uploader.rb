# encoding: utf-8

class ProfileUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  # Choose what kind of storage to use for this uploader:
  storage :fog

  def store_dir
    "users/#{model.id}/photos"
  end

  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    ActionController::Base.helpers.asset_path("fallback/default_profile.jpg")
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :resize_to_fit => [nil,600]

  version :thumb do
    process :resize_to_fill => [150, 150]
  end

end
