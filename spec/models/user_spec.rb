require 'spec_helper'

describe User do
  let(:user) {FactoryGirl.build(:user)}

  describe 'associations' do
    it { should have_many :listings }
    it { should have_many :sites }
  end


  describe 'profile_attribute_list' do
    it 'returns an array of attribute names' do
      expect(user.profile_attribute_list).to be_a Array
      expect(user.profile_attribute_list[0]).to be_a String
    end
  end

  describe 'profile_hash' do

    it 'returns a hash' do
      expect(user.profile_hash).to be_a Hash
    end
    it "contains the users attribute values" do
      user.profile_hash.each do |attr|
        user.send(attr[0]).should eq attr[1]
      end
    end
  end
end
