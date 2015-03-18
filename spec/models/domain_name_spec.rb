require 'spec_helper'

RSpec.describe DomainName, :type => :model do
  it {should validate_uniqueness_of :name}


  describe 'domain_is_available?' do
    let(:domain_name) {FactoryGirl.build(:domain_name)}

    context 'when domain is available' do
      let(:response) { OpenStruct.new(availability: 'AVAILABLE')}
      it 'returns true' do        
        domain_name.route53DomainsResource.stub(check_domain_availability: response)
        expect(domain_name.domain_is_available?).to be_truthy
      end 
    end

    context 'when domain is NOT available' do
      let(:response) { OpenStruct.new(availability: 'UNAVAILABLE')}
      it 'returns false' do
        domain_name.route53DomainsResource.stub(check_domain_availability: response)
        expect(domain_name.domain_is_available?).to be_falsey
      end
    end
  end
end
