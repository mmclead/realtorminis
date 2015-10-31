module AwsConnection
  extend ActiveSupport::Concern

  included do 

    def s3Resource(s3_region)
      @s3 ||= Aws::S3::Resource.new(region: s3_region)
    end

    def cfResource
      @cf ||= Aws::CloudFront::Client.new(region: 'us-west-2')
    end

    def route53DomainsResource
      @route53Domains ||= Aws::Route53Domains::Client.new(region: 'us-east-1')
    end

    def route53Resource
      @route53 ||= Aws::Route53::Client.new(region: "#{ENV['AWS_SITE_BUCKET_REGION']}")
    end

    def public_bucket_policy_json(site_bucket)
      {'Version' => '2012-10-17',
        'Statement' => [{
          'Sid' => 'AddPerm',
          'Effect' => 'Allow',
          'Principal' => '*',
          'Action' => ['s3:GetObject'],
          'Resource' => ["arn:aws:s3:::#{site_bucket.name}/*"]
        }]
      }.to_json
    end

    def get_bucket(s3, bucket_name, options = {})
      if s3.buckets.collect(&:name).include?(bucket_name)
        site_bucket = s3.bucket(bucket_name)
      else
        new_bucket = s3.bucket(bucket_name)
        new_bucket.create
        if options[:make_public] == true
          site_bucket.policy.put( policy: public_bucket_policy_json(bucket))
        end
        new_bucket
      end
    end
  end
end