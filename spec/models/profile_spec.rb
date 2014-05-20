require 'spec_helper'

describe Profile do

  let!(:user) {FactoryGirl.create(:user)}
  let(:profile) {user.profile}

  describe 'profile_attribute_list' do
    it 'returns an array of attribute names' do
      expect(profile.profile_attribute_list).to be_a Array
      expect(profile.profile_attribute_list[0]).to be_a String
    end
  end

  describe 'profile_hash' do

    it 'returns a hash' do
      expect(profile.profile_hash).to be_a Hash
    end
    it "contains the users attribute values" do
      profile.profile_hash.each do |attr|
        profile.send(attr[0]).should eq attr[1]
      end
    end
  end
end
