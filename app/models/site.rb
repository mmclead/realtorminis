class Site < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user

  validates_presence_of :listing
  validates_presence_of :site_code


  before_save :upload_to_aws


  def upload_to_aws
    #push the site_code blob up to aws
    #x-amz-storage-class request header to REDUCED_REDUNDANCY
    s3 = Aws::S3::Resource.new(region: "#{ENV['AWS_SITE_BUCKET_REGION']}")
    site_bucket = get_site_bucket(s3)
    site_bucket.policy.put( policy: site_bucket_policy_json(site_bucket))
    site = site_bucket.object("#{listing.slug}.html")
    site.put(body: site_code)

    self.bucket = site_bucket.name
    self.custom_url = site.key

  end

  def site_bucket_policy_json(site_bucket)
    {'Version' => '2012-10-17',
       'Statement' => [{
        'Sid' => 'AddPerm',
              'Effect' => 'Allow',
          'Principal' => '*',
            'Action' => ['s3:GetObject'],
            'Resource' => ["arn:aws:s3:::#{site_bucket.name}/*"
            ]
          }
        ]
      }.to_json
  end

  def get_site_bucket(s3)
    if s3.buckets.collect(&:name).include?("#{ENV['AWS_SITE_BUCKET']}")
      site_bucket = s3.bucket("#{ENV['AWS_SITE_BUCKET']}")
    else
      new_bucket = s3.bucket("#{ENV['AWS_SITE_BUCKET']}")
      new_bucket.tap{|bucket| bucket.create}
    end
  end

end
