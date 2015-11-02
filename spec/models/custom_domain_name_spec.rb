require 'spec_helper'

RSpec.describe CustomDomainName, :type => :model do
  it {should validate_uniqueness_of :name}

  let(:domain_name) {FactoryGirl.build(:domain_name)}
  
  describe 'domain_is_available?' do
    before {domain_name.route53DomainsResource.stub(check_domain_availability: response)}

    context 'when domain is available' do
      let(:response) {OpenStruct.new(availability: 'AVAILABLE')}
      it 'returns true' do        
        
        expect(domain_name.domain_is_available?).to be_truthy
      end 
    end

    context 'when domain is NOT available' do
      let(:response) {OpenStruct.new(availability: 'UNAVAILABLE')}
      it 'returns false' do
        expect(domain_name.domain_is_available?).to be_falsey
      end
    end
  end

  describe 'register_domain_with_route53' do
    let(:response) {OpenStruct.new(availability: 'UNAVAILABLE')}
    before {domain_name.route53DomainsResource.stub(check_domain_availability: response)}

    context 'when domain is not available' do
      let(:response) {OpenStruct.new(availability: 'UNAVAILABLE')}
      it 'returns false' do
        expect(domain_name.register_domain_with_route53).to be_falsey
      end
    end

    context 'when domain is available' do
      let(:response) {OpenStruct.new(availability: 'AVAILABLE')}
      context 'and the user has not paid for the domain' do
        before { domain_name.stub(is_paid_for?: false) }
        it 'returns false' do
          expect(domain_name.register_domain_with_route53).to be_falsey
        end
      end
      context 'and the user has paid for the domain' do
        before { domain_name.stub(is_paid_for?: true) }
        let(:domain_response_object) { OpenStruct.new(operation_id: SecureRandom.uuid) }

        it 'calls AWS to register the domain' do
          expect(domain_name.route53DomainsResource).to receive(:register_domain)
            .and_return(domain_response_object)
          expect(domain_name.route53DomainsResource).to receive(:get_operation_detail)
          domain_name.register_domain_with_route53

        end
      end
    end

    describe 'domain_is_registered?' do
      context 'when the user has not paid for the domain' do
        before { domain_name.stub(is_paid_for?: false) }
        it 'returns false' do
          expect(domain_name.domain_is_registered?).to be_falsey
        end
      end

      context 'when the user has paid for the domain' do
        before { domain_name.stub(is_paid_for?: true) }

        context 'when the status is already COMPLETE' do
          before {domain_name.stub(status: 'COMPLETE')}
          it 'returns true' do
            expect(domain_name.domain_is_registered?).to be_truthy
          end
        end
        context 'when the status is not COMPLETE yet' do
          it 'requests the domain regirstration status from AWS' do
            expect(domain_name.route53DomainsResource).to receive(:get_operation_detail)
            domain_name.domain_is_registered?
          end
          context 'when AWS says the operation is COMPLETE' do
            it "returns true and updates the domain's status with the returned value" do
              expect(domain_name.route53DomainsResource).to receive(:get_operation_detail)
                .and_return(OpenStruct.new(status: 'COMPLETE'))
              expect(domain_name.domain_is_registered?).to be_truthy
              expect(domain_name.status).to eq "COMPLETE"
            end
          end
          context 'when AWS says the operation is PENDING' do
            it "returns false and updates the domain's status with the returned value" do
              expect(domain_name.route53DomainsResource).to receive(:get_operation_detail)
                .and_return(OpenStruct.new(status: 'PENDING'))
              expect(domain_name.domain_is_registered?).to be_falsey
              expect(domain_name.status).to eq "PENDING"
            end
          end
        end
      end

      describe 'route_domain_to_listing_site' do
        context 'when domain_is_registered? is false' do
          before {domain_name.stub(domain_is_registered?: false)}
          it 'returns false' do
            expect(domain_name.route_domain_to_listing_site).to be_falsey
          end
        end
        context 'when domain is registered' do
          before {domain_name.stub(domain_is_registered?: true)}
          let(:zone_response) { OpenStruct.new(hosted_zone: {id: 1, name: "domain"}, change_info: {status: 'PENDING'}) }
          it 'calls AWS to route the domain to the custom domain name web page' do
            expect(domain_name.route53Resource).to receive(:create_hosted_zone)
              .and_return(zone_response)

            expect(domain_name.route53Resource).to receive(:change_resource_record_sets)
            domain_name.route_domain_to_listing_site
          end
        end
      end
    end
  end

end
