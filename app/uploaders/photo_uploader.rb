# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :resize_to_fit => [nil,600]

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [200,200]
  end

end
