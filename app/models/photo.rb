require 'aws/s3'

class Photo < ActiveRecord::Base

  include AwsConnection

  belongs_to :listing

  validates_presence_of :file_name, :file_content_type, :file_size, :key, :bucket

  default_scope { where(deleted: false) }

  before_validation(:on => :create) do
    self.file_name = key.split('/').last if key
    # for some reason, the response from AWS seems to escape the slashes in the keys, this line will unescape the slash
    self.url = url.gsub(/%2F/, '/') if url
    self.file_size ||= s3_object.content_length rescue nil
    self.file_content_type ||= s3_object.content_type rescue nil
  end
  # cleanup; destroy corresponding file on S3
  after_destroy { s3_object.try(:delete) }

  def to_jq_upload
    { 
      'id' => id,
      'url' => url,
      'name' => file_name,
      'type' => file_content_type,
      'size' => file_size,
      'image' => self.is_image?,
      'delete_url' => Rails.application.routes.url_helpers.listing_photo_path(listing.slug, self, :format => :json),
      'delete_type' => "DELETE"
    }
  end

  def is_image?
    !!file_content_type.try(:match, /image/)
  end

  #---- start S3 related methods -----
  def s3_object
    @s3_object ||= get_bucket(s3Resource(ENV['AWS_BUCKET_NAME_REGION']), bucket, {make_public: true}).object(key) if key && bucket
  rescue
    nil
  end


  #---- end S3 related methods -----

  def destroy
    self.deleted = true
    self.deleted_at = Time.now
    self.save
  end
  
end
