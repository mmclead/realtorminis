class S3Mocks 

  def stub_availability
    stub_request(:post, "https://route53domains.us-east-1.amazonaws.com/").
    with(:body => "{\"DomainName\":\"2403rockefellerlaneb.com\"}",
         :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'', 'Authorization'=>'AWS4-HMAC-SHA256 Credential=AKIAI7CV7ZIPOLHRPNCQ/20150419/us-east-1/route53domains/aws4_request, SignedHeaders=content-type;host;user-agent;x-amz-content-sha256;x-amz-date;x-amz-target, Signature=c14b7c352a3f8b2108c2b8b6683a5d8c0d000f07e84d813ce8a5ef959a1c3b56', 'Content-Length'=>'41', 'Content-Type'=>'application/x-amz-json-1.1', 'Host'=>'route53domains.us-east-1.amazonaws.com', 'User-Agent'=>'aws-sdk-ruby2/2.0.30 ruby/2.1.1 x86_64-darwin12.0', 'X-Amz-Content-Sha256'=>'8a0b09863826e1814537a5aaad1a8fd1331a78f143ba6e5662f7f51d5c3a92d0', 'X-Amz-Date'=>'20150419T061727Z', 'X-Amz-Target'=>'Route53Domains_v20140515.CheckDomainAvailability'}).
    to_return(:status => 200, :body => "", :headers => {})
  end
end