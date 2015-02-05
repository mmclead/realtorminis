require 'spec_helper'

describe Site do
  describe 'associations' do
    it { should belong_to :listing }
    it { should belong_to :user }
  end

  describe 'listing_must_be_paid_for' do
    let!(:listing) { FactoryGirl.build(:listing, id: 8)}
    let(:site) { FactoryGirl.build(:site, listing: listing)}
    it 'adds error to object when its parent listing is not paid for' do
      listing.stub(is_paid_for?: false)
      expect(site.valid?).to be_falsey
      expect(site.errors.full_messages.join(', ')).to match("Listing must be paid for in order to publish")
    end
    it 'saves when the parent listing is paid for' do
      listing.stub(is_paid_for?: true)
      expect(site.valid?).to be_truthy
    end
  end
end
