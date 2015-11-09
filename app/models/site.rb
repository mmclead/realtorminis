class Site < ActiveRecord::Base

  include AwsConnection

  belongs_to :listing
  belongs_to :user
  has_many :custom_domain_names, through: :listing

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

    site_key = push_site_to listing.web_address, site_bucket

    self.bucket = site_bucket.name
    self.custom_url = site_key
    self.active = true

    publish_custom_domains site_bucket
    logger.info "pushed to site_bucket and custom domains"
  end

  def destroy
    s3 = s3Resource("#{ENV['AWS_SITE_BUCKET_REGION']}")
    site_bucket = get_bucket(s3, "#{ENV['AWS_SITE_BUCKET']}")
    (custom_domain_names.all.map(&:name) + [listing.web_address]).flatten.each do |url|
      site = site_bucket.object("#{url}.html")
      site.delete()
    end
    self.update_column(:active, false)
  end

  def publish_custom_domains site_bucket=nil
    publish_custom_domains_to_site_bucket site_bucket    
  end

  def publish_custom_domains_to_site_bucket site_bucket=nil
    unless site_bucket
      s3 = s3Resource("#{ENV['AWS_SITE_BUCKET_REGION']}")
      site_bucket = get_bucket(s3, "#{ENV['AWS_SITE_BUCKET']}")
    end

    custom_domain_names.each do |custom_domain_name|
      push_site_to custom_domain_name.name, site_bucket if custom_domain_name.is_paid_for?
    end
  end

  def push_site_to custom_name, site_bucket
    site = site_bucket.object("#{custom_name}.html")
    site.delete()
    logger.info ("deleting #{site.key}")
    site.put(body: site_code, cache_control: "must-revalidate" )
    logger.info ("pushing new site to : #{site.key}")
    site.key
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