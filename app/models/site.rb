class Site < ActiveRecord::Base

  include AwsS3Connection

  belongs_to :listing
  belongs_to :user

  validates_presence_of :listing
  validates_presence_of :site_code

  before_validation :listing_must_be_paid_for
  before_save :upload_to_aws

  def active_status
    if active
      "<i class='glyphicon glyphicon-ok text-success'></i>"
    else
      "<i class='glyphicon glyphicon-remove text-danger'></i>"
    end
  end

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

 private
  def listing_must_be_paid_for
    unless listing.is_paid_for?
      errors.add(:listing, "must be paid for in order to publish")
    end
  rescue
    errors.add(:listing, "must be paid for in order to publish")
  end
end
