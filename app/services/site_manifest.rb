class SiteManifest
  include AwsConnection

  def current_manifest
    s3 = s3Resource("#{ENV['AWS_SITE_BUCKET_REGION']}")
    manifest_bucket = get_bucket(s3, "#{ENV['AWS_MANIFEST_BUCKET']}")

    manifest_bucket.object("index.html").get
  end

  def add_site_to_manifest
    
  end

  def remove_site_from_manifest

  end
end
