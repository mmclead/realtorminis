class Site < ActiveRecord::Base

  include AwsS3Connection

  belongs_to :listing
  belongs_to :user

  validates_presence_of :listing
  validates_presence_of :site_code


  before_save :upload_to_aws


  def upload_to_aws
    s3 = s3Resource("#{ENV['AWS_SITE_BUCKET_REGION']}")
    site_bucket = get_bucket(s3, "#{ENV['AWS_SITE_BUCKET']}")

    site = site_bucket.object("#{listing.slug}.html")
    site.delete()
    site.put(body: site_code)

    self.bucket = site_bucket.name
    self.custom_url = site.key
    self.active = true

  end

  def destroy
    s3 = s3Resource("#{ENV['AWS_SITE_BUCKET_REGION']}")
    site_bucket = get_bucket(s3, "#{ENV['AWS_SITE_BUCKET']}")

    site = site_bucket.object("#{listing.slug}.html")
    site.delete()
    self.update_column(:active, false)
  end


end
